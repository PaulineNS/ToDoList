import Foundation

struct Task {
    var title: String
    var done = false
    var text =
    """
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ultricies blandit velit, eu viverra mi feugiat non. Cras et venenatis eros, et facilisis nunc. Curabitur ac ornare tellus. Nullam posuere enim et nisi aliquet lobortis. Ut id tincidunt ipsum. Ut at libero in ligula fringilla luctus vel sit amet nunc. Proin sed ex quam. Etiam a consequat sapien. Nam tristique, nibh vitae sagittis sagittis, risus nulla consequat purus, eu molestie metus diam tincidunt lectus. Nam massa urna, porta sit amet lorem sit amet, pellentesque consectetur mi. Sed malesuada, mauris vel volutpat laoreet, urna nisl dictum nisl, eu auctor lectus sapien vitae leo. Quisque ultrices vestibulum nisl egestas bibendum.
 """
    var identifier: String = UUID().uuidString

    init(_ title: String) {
        self.title = title
    }

    fileprivate static let mockedList = [Task("task1"), Task("task2"), Task("Task3")]
}

class TaskService {

    func getTasks(success: @escaping([Task]) -> Void) {
        let random = 3.0 / Double.random(in: 2.0 ... 6.0)
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + random) {
            success(Task.mockedList)
        }
    }
    
    

}
