import CoreWLAN
import Foundation

// CLI helpers

private func basename(_ pathOption: String?) -> String? {
    if let path = pathOption {
        return URL(fileURLWithPath: path).lastPathComponent
    }
    return nil
}

private func printUsage() {
    let process = basename(CommandLine.arguments.first) ?? "executable"
    printErr("""
    Usage: \(process) -h|-help|--help
           \(process) -action interfaces|current|scan
           \(process) # same as: -action current
           \(process) -action associate -bssid bssid [-password password]
    """)
}

// CLI entry point

func main() {
    // use UserDefaults to parse other command line arguments
    let defaults = UserDefaults.standard
    let format = Format(rawValue: defaults.string(forKey: "format") ?? "tty") ?? .tty

    let client = CWWiFiClient.shared()
    let interface = client.interface()!

    var result = interfaceDictionary(interface)
    // timestamp with floating point seconds since epoch
    result["Timestamp"] = Date().timeIntervalSince1970
    try! serialize(result, format: format)

}

main()