package org.nyah
import org.nyah.config._

object Nyah {
    def main(args:Array[String]):Int = {
        var verbose = Value(false)
        var help = Value(false)
        var outputDir = Value(".")
        var cmdLine = new CmdLine
        cmdLine +=
            (("h", "help"), help, "display usage") +=
            (("v", "verbose"), verbose, "increase verbosity") +=
            (("o", "output-dir"), outputDir, "output directory")

        try {
            cmdLine.parse(args)
        }
        catch {
            case e:UnknownOption => {
                println("unknown option: " + e.key)
                cmdLine.help
                return 1
            }
        }

        if (help.value) {
            cmdLine.help
            return 0
        }

        return 0
    }
}
