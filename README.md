# Taskmaster

Taskmaster is a simple CLI tool which allows you to manage your tasks straight from your terminal.

Inspired by the CLI tool [Taskwarrior](https://github.com/taskwarrior/task)

## Prerequisites

- `ruby-3.4.x` (see `.ruby-version`)
- `bundler-2.x`
- `git`

## Local setup (Ruby + Bundler)

1. Clone the repository.

```
git clone https://github.com/mbuyco/taskmaster.git
cd taskmaster
```

2. Install gems.

```
bundle install
```

3. Initialize local task storage.

```sh
mkdir -p store
[ -f store/tasks.json ] || printf '{ "tasks": [] }\n' > store/tasks.json
```

> `install.sh` is deprecated and intentionally no longer installs Taskmaster.

## Docker setup (recommended for distribution)

Build image:

```sh
docker build -t taskmaster:latest .
```

Run commands with a persistent volume:

```sh
docker run --rm -it -v taskmaster-store:/app/store taskmaster:latest list
docker run --rm -it -v taskmaster-store:/app/store taskmaster:latest create "my task description"
docker run --rm -it -v taskmaster-store:/app/store taskmaster:latest edit 1 "new task description"
docker run --rm -it -v taskmaster-store:/app/store taskmaster:latest delete 1
```

The `taskmaster-store` volume persists tasks across container runs.

## Usage

### Local Ruby usage

```sh
bundle exec ruby bin/taskmaster.rb list
```

List tasks

```
bundle exec ruby bin/taskmaster.rb
```

-- or --

```
bundle exec ruby bin/taskmaster.rb list
```

Create a task

```
bundle exec ruby bin/taskmaster.rb create "my task description"
```

Modify task

```
bundle exec ruby bin/taskmaster.rb edit [task_id] "new task description"
```

Delete a task

```
bundle exec ruby bin/taskmaster.rb delete [task_id]
```

## Author

Mike Buyco <mbuyco@protonmail.com>
