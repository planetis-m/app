import owlkettle, owlkettle/adw

type
  TodoItem = object
    text: string
    done: bool

viewable App:
  todos: seq[TodoItem]
  newItem: string

method view(app: AppState): Widget =
  result = gui:
    Window(title = "Todo", defaultSize = (400, 300)):
      HeaderBar {.addTitlebar.}:
        MenuButton(icon = "open-menu-symbolic") {.addRight.}:
          Popover:
            Box(orient = OrientY, spacing = 6, margin = 6):
              Button(icon = "user-trash-symbolic", style = {ButtonDestructive}):
                proc clicked() =
                  for i in countdown(app.todos.high, 0):
                    if app.todos[i].done: delete(app.todos, i)

      Box(orient = OrientY, spacing = 6, margin = 12):
        Box(orient = OrientX, spacing = 6) {.expand: false.}:
          Entry(text = app.newItem):
            proc changed(newItem: string) =
              app.newItem = newItem

          Button(icon = "list-add-symbolic", style = {ButtonSuggested}) {.expand: false.}:
            tooltip = "Add an item to the list"
            proc clicked() =
              app.todos.add TodoItem(text: move app.newItem, done: false)
              app.newItem = ""

        Frame:
          ScrolledWindow:
            ListBox(selectionMode = SelectionNone):
              for it, todo in app.todos:
                Box(spacing = 6):
                  CheckButton(state = todo.done) {.expand: false.}:
                    proc changed(state: bool) =
                      app.todos[it].done = state

                  Label(text = todo.text, xAlign = 0)

adw.brew(gui(App(todos = @[])), colorScheme = ColorSchemeForceLight)
