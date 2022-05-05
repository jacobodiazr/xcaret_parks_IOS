import Foundation
import IOKit

func getMACAddress() -> String {
    let matching = IOServiceMatching("IOEthernetInterface") as NSMutableDictionary
    matching[kIOPropertyMatchKey] = ["IOPrimaryInterface": true]
    var servicesIterator: io_iterator_t = 0
    defer { IOObjectRelease(servicesIterator) }

    guard IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &servicesIterator) == KERN_SUCCESS else {
        return ""
    }

    var address: [UInt8] = [0, 0, 0, 0, 0, 0]
    var service = IOIteratorNext(servicesIterator)

    while service != 0 {
        var controllerService: io_object_t = 0

        defer {
            IOObjectRelease(service)
            IOObjectRelease(controllerService)
            service = IOIteratorNext(servicesIterator)
        }

        guard IORegistryEntryGetParentEntry(service, "IOService", &controllerService) == KERN_SUCCESS else {
            continue
        }

        let ref = IORegistryEntryCreateCFProperty(controllerService, "IOMACAddress" as CFString, kCFAllocatorDefault, 0)

        guard let data = ref?.takeRetainedValue() as? Data else {
            continue
        }

        data.copyBytes(to: &address, count: address.count)
    }

    return address
        .map { String(format: "%02x", $0) }
        .joined(separator: ":")
}