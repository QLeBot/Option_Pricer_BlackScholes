#!/bin/bash

# Function to setup and use venv
setup_venv() {
    if [ ! -d "venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv venv
    fi
    
    echo "Activating virtual environment..."
    source venv/bin/activate
    
    if [ -f "requirements.txt" ]; then
        echo "Installing requirements..."
        pip install -r requirements.txt
    fi
}

# Function to setup and use conda
setup_conda() {
    # Initialize conda for the current shell
    eval "$(conda shell.bash hook)"
    
    if ! conda env list | grep -q "option_pricer"; then
        echo "Creating conda environment from environment.yml..."
        conda env create -f environment.yml
    else
        echo "Updating conda environment from environment.yml..."
        conda env update -f environment.yml
    fi
    
    echo "Activating conda environment..."
    conda activate option_pricer
}

# Ask user for environment preference
echo "Choose environment type:"
echo "1) Python venv"
echo "2) Conda"
read -p "Enter your choice (1 or 2): " env_choice

case $env_choice in
    1)
        setup_venv
        ;;
    2)
        setup_conda
        ;;
    *)
        echo "Invalid choice. Defaulting to venv."
        setup_venv
        ;;
esac

# Run the Python script
echo "Running black_scholes_interactive.py..."
streamlit run black_scholes_interactive.py

# Deactivate environment
if [ "$env_choice" = "1" ]; then
    deactivate
elif [ "$env_choice" = "2" ]; then
    conda deactivate
fi
