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

block application:
  # DIとは「依存の注入」のこと。
  # 依存の注入という言葉が使われている書籍もあるので注意する
  # - StudentServiceを生成する際にAccountServiceを渡す
  # - この形にするとMockを使ったテストが書きやすい
  # - account_test_serviceみたいなやつも差し込める
  let account_service = AccoutService()
  let student_service = StudentService(account_service: account_service)
  assert @["B学生", "C学生"] == student_service.getUnregisteredStudentName()