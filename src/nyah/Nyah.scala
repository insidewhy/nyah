package org.nyah
import org.nyah.config._

object Nyah {
    def main(args:Array[String]):Int = {
        var verbose = Value(false)
        var outputDir = Value(".")
        var cmdLine = new CmdLine
        cmdLine += 
            (("v", "verbose"), verbose, "increase verbosity") += 
            ("o", outputDir, "output directory")

        try {
            cmdLine.parse(args)
        }
        catch {
            case e:UnknownOption => {
                println("unknown option: " + e.key)
                return 1
            }
        }

        return 0
    }
}
