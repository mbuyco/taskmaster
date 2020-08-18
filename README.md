# Taskmaster

Taskmaster is a simple CLI tool which allows you to manage your tasks straight from your terminal.

Inspired by the CLI tool [Taskwarrior](https://github.com/taskwarrior/task)

## Installation

1. Clone repo

```
git clone https://github.com/mbuyco/taskmaster.git $HOME/.taskmaster
```

2. Make executable (sudo privileges required)

```
sudo ln -s $HOME/.taskmaster/taskmaster.rb /usr/local/bin/taskm
```

## Usage

List tasks

```
taskm
```

-- or --

```
taskm list
```

Create a task

```
taskm create "my task description"
```

Modify task

```
taskm edit [task_id] "new task description"
```

Delete a task

```
taskm delete [task_id]
```

**TODO: Modify task status**

## Author

Mike Buyco <mbuyco@protonmail.com>
