import sequtils, sugar

type AccoutRecord = ref object
  id: int
  name*: string
  password: string

type AccoutService = ref object
method getAll*(service: AccoutService): seq[AccoutRecord] {.base.} =
  let acounts = @[
    AccoutRecord(id:1, name:"A学生", password: "fevxvbtr4"),
    AccoutRecord(id:2, name:"D学生", password: "sfref4erf"),
  ]

  return acounts

type Sex {.pure.} = enum
  MALE, FEMALE

type StudentRecord = ref object
  name*: string
  age: int
  sex: Sex
  pref: string

type StudentService = ref object
  account_service: AccoutService

method getAll*(service: StudentService): seq[StudentRecord] {.base.} =
  let students = @[
    StudentRecord(name:"A学生", age: 12, sex: Sex.MALE, pref: "北海道"),
    StudentRecord(name:"B学生", age: 14, sex: Sex.MALE, pref: "秋田県"),
    StudentRecord(name:"C学生", age: 11,sex: Sex.MALE, pref: "青森県")
  ]

  return students

method getUnregisteredStudentName(student_service :StudentService): seq[string] {.base.} =
  let account_names = student_service.account_service.getAll().map(m => m.name)
  let unregistered_students = 
    student_service.getAll()
                    .map(m => m.name)
                    .filter(f => not account_names.anyIt(it == f))

  return unregistered_students

type DIContainer = object
  student_service: StudentService

proc createDIContainer(): DIContainer =
  return DIContainer()

proc resolve(di_container: DIContainer, name: string): StudentService =
  case name: 
    of "Student":
      let account_service = AccoutService()
      let student_service = StudentService(account_service: account_service)
      return student_service
    else: discard

block application:
  # DIを使って引数が多くなってきたときに使う
  # 綺麗に見える
  let di_container = createDIContainer()
  # 本来resolveにはintefaceを利用
  assert @["B学生", "C学生"] == di_container.resolve("Student").getUnregisteredStudentName()