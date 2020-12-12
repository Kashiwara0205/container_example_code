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

# 本来はinterfaceを使って解決
type ServiceLocater = ref object
  account_service: AccoutService

proc createServiceLocater(): ServiceLocater = ServiceLocater()

method register(service_locater: ServiceLocater, name: string): void {.base.} =
  case name: 
    of "Account":  service_locater.account_service = AccoutService()
    else: discard

method resolve(service_locater: ServiceLocater, name: string): AccoutService {.base.} =
  case name: 
    of "Account": return service_locater.account_service
    else: discard

type Sex {.pure.} = enum
  MALE, FEMALE

type StudentRecord* = ref object
  name*: string
  age: int
  sex: Sex
  pref: string

type StudentService = ref object
  service_locator*: ServiceLocater

method getAll*(service: StudentService): seq[StudentRecord] {.base.} =
  let students = @[
    StudentRecord(name:"A学生", age: 12, sex: Sex.MALE, pref: "北海道"),
    StudentRecord(name:"B学生", age: 14, sex: Sex.MALE, pref: "秋田県"),
    StudentRecord(name:"C学生", age: 11,sex: Sex.MALE, pref: "青森県")
  ]

  return students

method getUnregisteredStudentName(student_service :StudentService): seq[string] {.base.} =
  # 本来はinterfaceを使って呼び出し
  let account_names = student_service.service_locator.resolve("Account").getAll().map(m => m.name)
  let unregistered_students = 
    student_service.getAll()
                   .map(m => m.name)
                   .filter(f => not account_names.anyIt(it == f))

  return unregistered_students

block test:
  # 本来はinterfaceを使って定義する
  # なのでstringを使って定義するわけではない
  let service_locator = createServiceLocater()
  service_locator.register("Account")
  let student_service = StudentService(service_locator: service_locator)
  assert @["B学生", "C学生"] == student_service.getUnregisteredStudentName()
  