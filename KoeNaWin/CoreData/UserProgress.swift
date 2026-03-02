final class UserProgress: NSManagedObject {
    @NSManaged var startDate: Date
    @NSManaged var currentStage: Int16
    @NSManaged var dayOfStage: Int16
    @NSManaged var completedDays: Data
    @NSManaged var reminder: Date
}