type AccoutRecord* = ref object
  id: int
  name*: string
  password: string

type AccoutModel* = ref object
method getAll*(model: AccoutModel): seq[AccoutRecord] {.base.} =
  let acounts = @[
    AccoutRecord(id:1, name:"A学生", password: "fevxvbtr4"),
    AccoutRecord(id:2, name:"D学生", password: "sfref4erf"),
  ]

  return acounts