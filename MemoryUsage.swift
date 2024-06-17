import UIKit

func getMemoryUsage() -> (used: UInt64, total: UInt64) {
    let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size) / 4
    var vmInfo = task_vm_info_data_t()
    var count = TASK_VM_INFO_COUNT
    let result: kern_return_t = withUnsafeMutablePointer(to: &vmInfo) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
        }
    }
    if result != KERN_SUCCESS {
        return (0, 0)
    }

    let used = vmInfo.phys_footprint
    let total = ProcessInfo.processInfo.physicalMemory
    return (used, total)
}