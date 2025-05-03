# Tic-Tac-Toe in Ruby

A command-line implementation of the classic game Tic-Tac-Toe built in Ruby, demonstrating object-oriented design principles, including Strategy, Observer, Decorator, Factory, Builder, and Command patterns.

## Description

This project provides a flexible and extensible command-line Tic-Tac-Toe game. It supports Human versus AI gameplay with a basic random AI, variable board sizes, move logging, and includes the foundational structure for implementing an undo feature using the Command pattern.

## Features

* **Human vs. AI Gameplay:** Play against a simple computer opponent.
* **Variable Board Size:** Easily configure the game board size (default is 3x3).
* **Move Logging:** Tracks and reports player moves.
* **Basic AI:** The AI randomly selects an available cell.
* **Extensible Design:** Built with several design patterns to make adding new features (like different AI levels or game modes) easier.
* **Command Pattern Integration:** Includes the `CommandManager` and `PlaceMarkCommand` classes, providing the groundwork for an undo feature.

## Project Structure

The core game logic is organized within the `lib/tictactoe` directory, following a standard Ruby library structure. Custom Rake tasks are located in `lib/tasks`.

## Setup

To get this project running on your local machine:

1.  **Prerequisites:**
    * Ruby (version 2.x or higher recommended)
    * Bundler gem (`gem install bundler`)
    * Rake gem (usually included with Ruby, but can be installed via `gem install rake`)

2.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```
    (Replace `<repository_url>` and `<repository_directory>` with your project's actual details)

3.  **Install dependencies:**
    ```bash
    bundle install
    ```

4.  **Configure Autoloading (Optional but Recommended in Rails):**
    If you are integrating this into a Rails application, ensure your `lib/tictactoe` directory is in your autoload paths. Add the following to `config/application.rb`:
    ```ruby
    # config/application.rb
    module YourAppName
      class Application < Rails::Application
        # ... other configurations

        # Autoload and eager load the 'lib/tictactoe' directory
        config.eager_load_paths << Rails.root.join('lib', 'tictactoe')

        # ... rest of your configuration
      end
    end
    ```
    If not in a Rails app or if relying on Rake task requires, ensure `lib/tictactoe/tictactoe.rb` is correctly required in `lib/tasks/play.rake`.

## How to Play

The game is started using a Rake task.

1.  Navigate to the project's root directory in your terminal.
2.  Run the default Rake task:
    ```bash
    rake
    ```
    or specifically the play task:
    ```bash
    rake play
    ```

3.  When prompted as the Human Player, enter your move by typing the row and column indices separated by a space (e.g., `0 0` for the top-left corner, `1 2` for the second row, third column).

    ```
    Starting Tic-Tac-Toe game!
    Game started.

    It's Player 1's turn (X)
    Player 1 (X), enter your move (row col):
    1 1
    -------------
    |   |   |   |
    -------------
    |   | X |   |
    -------------
    |   |   |   |
    -------------

    It's Player 2's turn (O)
    ... and so on
    ```

## Future Enhancements

* **Full Undo Feature:** Implement user input handling (e.g., typing 'undo') to trigger the `CommandManager#undo` functionality in the `GameController`.
* **More Sophisticated AI:** Replace the random AI with an AI that uses algorithms like Minimax for better strategy.
* **Player vs. Player Mode:** Add an option to play against another human player.
* **Graphical User Interface (GUI):** Develop a visual interface for the game instead of the command line.
* **Input Robustness:** Add more robust input handling in the Rake task or controller to catch non-numeric input more gracefully.
* **Comprehensive Test Suite:** Write unit and integration tests for all classes and functionalities.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details. (Create a LICENSE.md file with the MIT license text if you haven't already).