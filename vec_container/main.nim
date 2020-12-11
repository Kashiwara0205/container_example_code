import sequtils, sugar
import ../models/account
import ../models/student

type VecContainer = object
  student_model*: student.StudentModel
  account_model*: account.AccoutModel

proc createVecCntainer():VecContainer =
  let student_model = student.StudentModel()
  let account_model = account.AccoutModel()

  return VecContainer(student_model: student_model, account_model: account_model)

type ApplicationService = ref object
  vec_container: VecContainer

method getUnregisteredStudentName(service :ApplicationService): seq[string]  {.base.} =
  let account_names = service.vec_container.account_model.getAll().map(m => m.name)
  let unregistered_students = 
    service.vec_container.student_model.getAll()
                         .map(m => m.name)
                         .filter(f => not account_names.anyIt(it == f))

  return unregistered_students

block test:
  let service = ApplicationService(vec_container: createVecCntainer())
  assert @["B学生", "C学生"] == service.getUnregisteredStudentName()