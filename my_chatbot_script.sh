#!/bin/bash

# Download the NLTK data (if not already downloaded)
python3 -m nltk.downloader vader_lexicon

# Create a sentiment analyzer
python3 <<EOF
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
sentiment_analyzer = SentimentIntensityAnalyzer()
EOF

# Define patterns and responses
patterns=(
 "(hi|hello|hey)=('Hello!', 'Hi there!', 'Hey!')"
 "(how are you)=('I am doing well, thank you!', 'I am a chatbot, so I don\'t have feelings, but thanks for asking!')"
 "(what is your name)=('I am a chatbot created with NLTK.', 'You can call me Chatbot.')"
 "(weather)=('I am not connected to the internet, so I cannot provide real-time weather information.')"
 "(bye|goodbye)=('Goodbye!', 'Bye! Have a great day.')"
 "(.*)=('I\'m sorry, I don\'t understand.')"
)

# Knowledge Base dictionary
knowledge_base=(
 ['python', 'Python is a versatile programming language often used for web development, data analysis, and artificial intelligence.']
 ['nlp', 'Natural Language Processing (NLP) is a field of study focusing on the interaction between computers and human languages.']
 ['chatbot', 'A chatbot is a computer program designed to simulate conversation with human users, providing information or assistance.']
 ['machine learning', 'Machine learning is a subset of artificial intelligence that enables computers to learn from data and make predictions or decisions.']
 ['data science', 'Data science is a multidisciplinary field that uses scientific methods, processes, algorithms, and systems to extract insights from structured and unstructured data.']
 ['algorithm', 'An algorithm is a step-by-step procedure or formula for solving problems or accomplishing tasks.']
 ['neural network', 'A neural network is a set of algorithms modeled after the human brain, designed to recognize patterns.']
 ['programming', 'Programming is the process of designing and building an executable computer program for accomplishing a specific task.']
 ['web development', 'Web development involves building and maintaining websites and web applications.']
 ['cloud computing', 'Cloud computing is the delivery of computing services, including servers, storage, databases, networking, analytics, and intelligence, over the internet to offer faster innovation and flexible resources.']
)

# Predefined user credentials
valid_username="user123"
valid_password="pass123"

# Create a chatbot
chatbot_responses(){
 echo "Response: $1"
 sleep 1
}

chatbot(){
 local user_input
 while true; do
   echo "Enter username"
   read -p "Response: " username
   echo "Enter password"
   read -p "Response: " password

   if [[ $username == $valid_username && $password == $valid_password ]]; then
     echo "Authentication successful! You can now chat with the bot."
     chatbot_responses "Authentication successful! You can now chat with the bot."
     break
   else
     echo "Invalid credentials. Please try again."
     chatbot_responses "Invalid credentials. Please try again."
   fi
 done

 echo "Hello! I'm your chatbot. Type 'bye' to exit."

 while true; do
   read -p 'Response: ' user_input

   if [[ $user_input == 'bye' ]]; then
     echo 'Goodbye!'
     break
   fi

   echo "User Input: $user_input"
   chatbot_responses "Analyzing user input..."

   lang=$(langid --line "$user_input" | cut -d':' -f1)

   if [[ $lang == 'en' ]]; then
     echo "Language: English"
     sentiment_score=$(python3 <<EOF
     from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
     analyzer = SentimentIntensityAnalyzer()
     print(analyzer.polarity_scores('$user_input'))
EOF
     )
     echo "Sentiment: $sentiment_score"

     if [[ $user_input == *python* ]]; then
       echo "Response: ${knowledge_base[0][1]}"
       chatbot_responses "${knowledge_base[0][1]}"
     else
       echo "Response: ${patterns[5]}"
       chatbot_responses "${patterns[5]}"
     fi
   elif [[ $lang == 'es' ]]; then
     echo "Language: Spanish"
     echo "Response: Lo siento, actualmente solo hablo inglés."
     chatbot_responses "Lo siento, actualmente solo hablo inglés."
   else
     echo "Language: Unknown"
     echo "Response: I'm sorry, I don't understand other languages at the moment."
   fi
 done
}

# Run the chatbot
chatbot

