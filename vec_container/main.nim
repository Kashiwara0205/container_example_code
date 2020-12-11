import sequtils, sugar
import ../common/model

type VecContainer = object
  student_model*: model.StudentModel
  account_model*: model.AccoutModel

proc createVecCntainer():VecContainer =
  let student_model = model.StudentModel()
  let account_model = model.AccoutModel()

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