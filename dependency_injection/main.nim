import sequtils, sugar
import ../models/account
import ../models/student

type ApplicationService = ref object
  student_model: student.StudentModel
  account_model: account.AccoutModel

method getUnregisteredStudentName(service :ApplicationService): seq[string] {.base.} =
  let account_names = service.account_model.getAll().map(m => m.name)
  let unregistered_students = 
    service.student_model.getAll()
                         .map(m => m.name)
                         .filter(f => not account_names.anyIt(it == f))

  return unregistered_students

block test:
  let student_model = student.StudentModel()
  let account_model = account.AccoutModel()
  let service = ApplicationService(student_model: student_model, account_model: account_model)

  assert @["B学生", "C学生"] == service.getUnregisteredStudentName()