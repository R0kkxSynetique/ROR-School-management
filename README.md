# School Management System

A system for managing school.

## About The Project

This project is designed to streamline school management processes, providing a centralized platform for handling various operations.

### Built With

[![Ruby][Ruby-shield]][Ruby-url]
[![ROR][ROR-shield]][ROR-url]
[![Tailwind CSS][Tailwind-shield]][Tailwind-url]
[![Devise][Devise-shield]][Devise-url]
[![Foreman][Foreman-shield]][Foreman-url]

## Getting Started

This section will guide you through setting up the project locally.

### Prerequisites

Before you begin, ensure you have the following installed:
* Ruby (version 3.3.1)
* Foreman (version 0.88.1)

### Installation

1. Clone the repository

```bash
git clone https://github.com/R0kkxsynetique/schoolManagement.git
```

2. Install dependencies

```bash
bundle install
```

3. Set up the database

```bash
rails db:migrate
```

> Optional: If you want to seed the database with initial data, run:

```bash
rails db:seed
```

4. Start the development server

```bash
foreman start -f Procfile.dev
```

## Usage

<!-- TODO GIFs with example -->

## Roadmap

* [X] School classes management
* [X] Courses management
* [X] Report cards management
* [X] Students management
* [X] Employees management
* [X] Grades management
* [X] Examinations management

## License

Distributed under no license.

[Ruby-shield]: https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[Ruby-url]: https://www.ruby-lang.org/en/
[Foreman-shield]: https://img.shields.io/badge/Foreman-2B2D42?style=for-the-badge&logo=foreman&logoColor=white
[Foreman-url]: https://github.com/ddollar/foreman
[ROR-shield]: https://img.shields.io/badge/Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white
[ROR-url]: https://rubyonrails.org/
[Tailwind-shield]: https://img.shields.io/badge/Tailwind%20CSS-06B6D4?style=for-the-badge&logo=tailwind-css&logoColor=white
[Tailwind-url]: https://tailwindcss.com/
[Devise-shield]: https://img.shields.io/badge/Devise-4A154B?style=for-the-badge&logo=devise&logoColor=white
[Devise-url]: https://github.com/heartcombo/devise
