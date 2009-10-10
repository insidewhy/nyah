package org.nyah
import org.nyah.config._

object Nyah {
    def main(args:Array[String]) {
        var verbose = Value(false)
        var outputDir = Value(".")
        var cmdLine = new CmdLine
        cmdLine += 
            ("v", verbose, "increase verbosity") += 
            ("o", outputDir, "output directory")
        cmdLine.parse(args)
    }
}
