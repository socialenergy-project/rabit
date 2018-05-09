# README

This repository is the Research Algorithm Toolkit, developed in the context
of the Horizon 2020 SocialEnergy project http://socialenergy-project.eu/.

The purpose of this module is to allow administrators or privileged RAT users
to evaluate the performance of different pricing algorithms, on the portfolio
of the SocialEnergy user base.

The portal is available at https://rat.socialenergy-project.eu.


## Installation steps

1.  Clone the repository into a directory on the local computer, and enter
    the directory

        git clone https://github.com/socialenergy-project/rat.git
        cd rat/

2.  Install `ruby` version `2.4.1`, using `rbenv`. Installation instructions for
    `rbenv` may be found here https://github.com/rbenv/rbenv#installation

3.  Install postgres, create database user for rat, and setup password:

        sudo apt install postgresql-common
        sudo apt install libpq-dev

        sudo -u postgres createuser rat -s
        sudo -u postgres psql
        postgres=# \password rat

4.  Setup the environment variables for the project. First create a `.env` file,
    using the provided sample:

        cp -i .env.sample .env

    and then edit the file to provide the appropriate values.

        SECRET_KEY_BASE=f24...
        RAT_DATABASE_PASSWORD=aCZ..

        SMTP_USERNAME=user@gmail.com
        SMTP_PASSWORD=pass

    - The value for `SECRET_KEY_BASE` variable is obtained by executing `rails secret`.
    - The value for `RAT_DATABASE_PASSWORD` variable is the password set for user
      `rat` in the previous step.
    - The values for `SMTP_USERNAME` and `SMTP_PASSWORD` are used for connecting
      to gmail to send emails. Different mail servers may be added by editing file
      `config/initializers/smtp_settings.rb`

5.  Install the required gems:

        bundle install

6.  Create the project database

        rails db:create
        rails db:migrate

7.  Now you can the server with the command

        rails s

    You can then visit the site by opening a browser at http://localhost:3000/

8.  In order to be able to run the algorithms, you need to install the
    "pricing algorithms" submodule
    https://bitbucket.org/socialenergy-iccs/crtp_prtp_rtp,
    in a direct subdirectory of this repo, with the default name.

    Ensure that the submodule is installed correctly, by following the instruction
    in the corresponding README file.


## Registration and mock data

In order to use the RAT platform as a standalone platform, an admin user must be
created, and the database needs to be initialized with consumers and other objects.
Finally consumption data for the consumers must be added to the database.
The steps for this follow:

### Register admin user

1.  Start the server by running command `rails s` from the installation directory

2.  Open a browser window at location http://localhost:3000/

3.  Register a new user using the `Sign up` link (or navigate to http://localhost:3000/users/sign_up).
    Set an email and a password and submit the form
    
4.  To make the user an administrator, navigate to the project 
    directory, and execute:
    
         rails console
         
    In the prompt that appears execute the command:
    
         User.find_by(email: 'YOUR_EMAIL').add_role :admin
    
### Database initialization

1.  Decompress the file with consumption data:

        bunzip2 --keep db/initdata/DataPoint.csv.bz2
    
    A file named `db/initdata/DataPoint.csv` should be created.
    
2.  Run the script to seed the database with initial data:

        rails db:seed

    After this command, navigating to https://localhost:3000/, on should be able to see consumers,
    with consumption data for the dates from 1/1/2015 to 30/9/2016
    

## Navigation and visualization
