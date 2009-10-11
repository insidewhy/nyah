package org.nyah.config
import scala.collection.mutable.HashMap
import scala.collection.mutable.Queue

class UnknownOption(unknownKey:String) extends Throwable {
    val key = unknownKey
}

class CmdLineIterator(args:Array[String]) {
    var idx = 0
    var position = 0
    var value = if (args.size > 0) args(0) else ""

    def atEnd = idx >= args.size
    def +=(inc:Int) {
        idx += inc
        value = if (args.size > idx) args(idx) else ""
    }
    def size = value.size - position
    def front = value(position)
    def positionedValue = value.substring(position)
}

abstract class ValueAbstract {
    def apply(argIt:CmdLineIterator)
    def after(argIt:CmdLineIterator):Boolean
}

abstract class Value[T](default:T) extends ValueAbstract {
    var value = default
}

object Value {
    def apply(arg:Boolean):BoolValue = {
        return new BoolValue(arg)
    }

    def apply(arg:String):StringValue = {
        return new StringValue(arg)
    }

    def apply(arg:Int):IntValue = {
        return new IntValue(arg)
    }
}

class BoolValue(default:Boolean) extends Value[Boolean](default) {
    override def apply(argIt:CmdLineIterator) {
        value = true
    }

    override def after(argIt:CmdLineIterator):Boolean = {
        value = true
        argIt.size > 0
    }
}

class StringValue(default:String) extends Value[String](default) {
    override def apply(argIt:CmdLineIterator) {
        value = argIt.value
        argIt += 1
    }

    override def after(argIt:CmdLineIterator):Boolean = {
        value = argIt.positionedValue
        argIt += 1
        false
    }
}

class IntValue(default:Int) extends Value[Int](default) {
    override def apply(argIt:CmdLineIterator) {
        value = argIt.value.toInt
        argIt += 1
    }

    override def after(argIt:CmdLineIterator):Boolean = {
        value = argIt.positionedValue.toInt
        argIt += 1
        false
    }
}

class CmdLine {
    private var values = new HashMap[String, ValueAbstract]
    private var descriptions = new Queue[HelpDescription]
    var positionals = new Queue[String]

    class HelpDescription(aKey:String, aDescription:String, aAlternates:List[String]) {
        val key = aKey
        val description = aDescription
        var alternates:List[String] = aAlternates

        def headerSize:Int = {
            if (alternates == Nil) keySize(key)
            else (2 * (alternates.size - 1)) +
                aAlternates.foldLeft(keySize(key) + 5) { _ + keySize(_) }
        }

        private def keySize(key:String) =
            if (key.size > 1) 2 + key.size else 1 + key.size

        private def keyString(key:String) =
            if (key.size > 1) "--" + key else "-" + key

        def header:String = {
            if (alternates == Nil) "  " + keyString(key) + " "
            else
                "  " + keyString(key) + " [ " +
                    alternates.map(keyString(_)).reduceLeft(_ + ", " + _) + " ]"
        }
    }

    def +=(keys:String, value:ValueAbstract, desc:String):CmdLine = {
        values += keys -> value
        descriptions += new HelpDescription(keys, desc, Nil)
        return this
    }

    def +=(keys:(String, String), value:ValueAbstract, desc:String):CmdLine = {
        values += keys._1 -> value
        values += keys._2 -> value
        descriptions += new HelpDescription(keys._1, desc, keys._2 :: Nil)
        return this
    }

    def +=(keys:(String, String, String), value:ValueAbstract, desc:String):CmdLine = {
        values += keys._1 -> value
        values += keys._2 -> value
        values += keys._3 -> value
        descriptions += new HelpDescription(keys._1, desc, keys._2 :: keys._3 :: Nil)
        return this
    }

    def help {
        val maxLength = Iterable.max(descriptions.map( _.headerSize )) + 3
        descriptions.foreach((desc:HelpDescription) => {
            val thisHeader = desc.header
            print(thisHeader +  " " * (maxLength - thisHeader.size))
            println(desc.description)
        })
    }

    def parse(args:Array[String]) {
        var it = new CmdLineIterator(args)
        while (! it.atEnd) {
            if (it.value.size > 1 && it.value(0) == '-') {
                if (it.value(1) == '-') {
                    if (it.size == 2) {
                        it += 1
                        while (! it.atEnd) {
                            positionals += it.value
                            it += 1
                        }
                    }
                    else {
                        val search = it.value.substring(2)
                        if (values.contains(search)) {
                            it += 1
                            values(search)(it)
                        }
                        else throw new UnknownOption(search)
                    }
                }
                else {
                    it.position = 1
                    var good = false
                    do {
                        val search = it.front.toString
                        if (values.contains(search)) {
                            if (it.size == 1) {
                                it += 1
                                it.position = 0
                                values(search)(it)
                                good = false
                            }
                            else {
                                it.position += 1
                                good = values(search).after(it)
                            }
                        }
                        else throw new UnknownOption(search)
                    } while (good)
                }
            }
            else positionals += it.value
        }
    }
}
