
type Sex {.pure.} = enum
  MALE, FEMALE

type StudentRecord* = ref object
  name*: string
  age: int
  sex: Sex
  pref: string

type StudentModel* = ref object
method getAll*(model: StudentModel): seq[StudentRecord] {.base.} =
  let students = @[
    StudentRecord(name:"A学生", age: 12, sex: Sex.MALE, pref: "北海道"),
    StudentRecord(name:"B学生", age: 14, sex: Sex.MALE, pref: "秋田県"),
    StudentRecord(name:"C学生", age: 11,sex: Sex.MALE, pref: "青森県")
  ]

  return students