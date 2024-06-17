import UIKit

func getCoreUsage() -> [Double] {
    var coreUsage: [Double] = []
    var kr: kern_return_t
    var task_info_count: mach_msg_type_number_t

    task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
    var tinfo = task_basic_info()

    kr = withUnsafeMutablePointer(to: &tinfo) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), $0, &task_info_count)
        }
    }

    if kr != KERN_SUCCESS {
        return []
    }

    var thread_list: thread_act_array_t?
    var thread_count: mach_msg_type_number_t = 0
    defer {
        if let thread_list = thread_list {
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: thread_list), vm_size_t(thread_count))
        }
    }

    kr = task_threads(mach_task_self_, &thread_list, &thread_count)
    if kr != KERN_SUCCESS {
        return []
    }

    if let thread_list = thread_list {
        for j in 0..<thread_count {
            var thinfo = thread_basic_info()
            var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
            kr = withUnsafeMutablePointer(to: &thinfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    thread_info(thread_list[Int(j)], thread_flavor_t(THREAD_BASIC_INFO), $0, &thread_info_count)
                }
            }
            if kr != KERN_SUCCESS {
                return []
            }

            if thinfo.flags & TH_FLAGS_IDLE == 0 {
                coreUsage.append((Double(thinfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0)
            }
        }
    }
    return coreUsage
}