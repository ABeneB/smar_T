![smarT](./app/assets/images/Logo.svg)

The powerful and unique vehicle routing software for small and micro businesses. It is resource-efficient and could be deployed as SaaS application or on-premise. 

## Features

 - Optimization of vehicle routes through the combination of three different heuristics (M3PDP, Delta-M3PDP and Savings++)
 - automatic calculation of ETA
 - intuitive user interface
 - allows subsequent modification of generated tour 
 - PDF / Print feature for route planning
 - Auto-complete of addresses
 - extensive validation of user inputs
 - Windows support via JRuby
 - Searchable orders and customers

## Prerequisites

 - Ruby.2.x - 2.4.x  
 - ImageMagic 7.0.7-22
 - wkhtmltopdf 0.12.4 (for PDF generation)

**only for Windows support:**
 -  JRuby v.9.1.13.0 (instead of regular Ruby)
 -  JRE (Java Runtime Environment) v.8.144

## Installation

 Get the repository 


    git clone https://github.com/nielspetersen/smar_T.git
    cd smar_T

> **Note:** The following steps are ony valid for Linux / Unix systems. See below for instructrions on how to set up smar[T] in an Windows environment.  

Update your bundle

    bundle install

and setup database (and run migrations)

    rake db:setup

**Installation on Windows**:

```
git checkout jruby # switch to separate branch
jruby -S gem install bundler
jruby -S bundle install
jruby -S rake db:setup
jruby -S rails server
```
## Run application

Execute 

    rails server
or 

    rails server -b 0.0.0.0 -p 3000
to make the Rails application accessible to others in the same network. 

## Reference

Based on work of: 

\[1\] Brendel, A. B. (2015) *Konzeptionierung eines ressourcen- und kosteneffizienten green Software-as-a-Service Tourenplanungssystems für Kleinst- und Kleinunternehmen*, Masterthesis, University of Göttingen

\[2\] Kindermann, P. *Tourenplanung mit Zeitfenstern für mehrere Fahrzeuge*, Diploma thesis,  University of Würzburg