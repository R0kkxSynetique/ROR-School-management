# Report

## Conceptual Data Model (CDM)

### Updates made to the base CDM

#### Authentication and People entity

- Added User entity to handle authentication through Devise
- Made the inheritance explicit with proper STI (Single Table Inheritance) implementation
- People have a polymorphic type field for STI ("Student", "Employee", "Dean")
- Added status field ("active"/"archived") for soft deletion
- Employees have additional type field to differentiate roles
- All people require an address with proper international format
- Removed iban from base People entity, moved to Employee

<table>
<tr>
<th> Before </th>
<th> After </th>
</tr>
<tr>
<td>

```mermaid
classDiagram
    class people{
        username$
        lastname
        firstname
        email
        phone_number
        type
        iban
    }
    class statuses{
        slug$
        name
    }

    people "1,1" -- "0,n" statuses: is
```

</td>
<td>

```mermaid
classDiagram
    class people {
        username$
        lastname
        firstname
        email
        phone_number
        status
        type
    }
    class students {
    }
    class employees {
        iban
        type
    }

    people <|-- students
    people <|-- employees
```

</td>
</table>

#### Role-Based Structure

- Dean is now a specialized type of Employee with additional management capabilities
- Employees (including teachers) have specialized relationships:
  - Can teach courses
  - Can plan examinations
  - Can give grades
  - Can masterize classes
  - Have specializations (areas of expertise)
- Students have their own specialized relationships:
  - Can be enrolled in classes
  - Receive grades
  - Take examinations

<table>
<tr>
<th> Before </th>
<th> After </th>
</tr>
<td>

```mermaid

classDiagram
    class people {...}
    class classes{...}
    class grades {...}

    people "0,n" -- "0,n" classes: to follow
    people "0,n" -- "0,1" classes: to masterize
    people "0,n" -- "1,1" grades: to have

```

</td>
<td>

```mermaid
classDiagram
    class employees {
        iban
        type
    }
    class students { }
    class courses {
        name
        description
        status
    }
    class grades {
        value
        effective_date
    }
    
    employees "0,n" -- "0,n" courses: teaches
    employees "0,n" -- "1,n" grades: gives
    students "0,n" -- "1,1" grades: receives
```

</td>
</tr>
</table>

#### Academic Structure

- Improved course and class management with clear separation of concerns

<table>
<tr>
<th> Before </th>
<th> After </th>
</tr>
<td>

```mermaid
classDiagram
    class courses {
        name
        description
    }
    class classes {
        name
    }
    class rooms {
        name
    }

    classes "0,n" -- "1,1" rooms: uses
    classes "0,n" -- "0,n" courses: follows
```

</td>
<td>

```mermaid
classDiagram
    class courses {
        name
        description
        status
    }
    class classes {
        uid
        name
    }
    class rooms {
        name
    }
    class schedules {
        start_time
        end_time
        week_day
    }
    
    courses "1,1" -- "0,n" rooms: isIn
    classes "0,n" -- "0,n" courses: follows
    courses "1,1" -- "0,n" schedules: hasSchedule
```

</td>
</tr>
</table>

#### Promotion Management

- Enhanced promotion management with proper conditions and relationships

<table>
<tr>
<th> Before </th>
<th> After </th>
</tr>
<td>

```mermaid
classDiagram
    class promotion_assertions {
        function
    }
    class sections {
        name
    }

    sections "1,1" -- "0,n" promotion_assertions: has
```

</td>
<td>

```mermaid
classDiagram
    class promotion_asserments {
        effective_date
        condition
    }
    class sections {
        name
        description
    }
    class dean { }

    sections "1,n" -- "0,n" promotion_asserments: evaluates
    dean "1,1" -- "0,n" promotion_asserments: manages
```

</td>
</tr>
</table>
