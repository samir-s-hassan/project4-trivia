# Project 4 - Trivia

Submitted by: Samir Hassan

Trivia is an app that allows users to answer questions retrieved from the Open Trivia Database API. These questions have multiple answers, range in difficulty, and are from different categories. The questions can either be multiple choice or True and False. Users have the option to reset the game and view their score after completing at least 5 questions.

Time spent: 4 hours spent in total

## Required Features

The following **required** functionality is completed:

- [X] User can view and answer at least 5 trivia questions.
- [X] App retrieves question data from the Open Trivia Database API.
- [X] Fetch a different set of questions if the user indicates they would like to reset the game.
- [X] Users can see score after submitting all questions.
- [X] True or False questions only have two options.


The following **optional** features are implemented:
  
- [ ] Allow the user to choose a specific category of questions.
- [ ] Provide the user feedback on whether each question was correct before navigating to the next.

The following **additional** features are implemented:

N/A

## Video Walkthrough

[Video]](https://www.loom.com/share/b74691d2831746c4b4b55472bd45f942?sid=0ee4e089-d31d-4e3e-8345-38b57d699a54) .

## Notes

- This is the API I used: https://opentdb.com/api_config.php

One challenge I had while building this app was decoding the HTML encoding into string. I received back HTML code from the API request and initially some characters would be misrepresented in the string. I created a function that decodes this HTML and puts it into proper string. Another challenge I had was getting the game to reset once the user finished such that the user would have a set of different questions. I was able to do this by putting the fetching the trivia questions into a function and then calling that function once the game ended. This way the function would call another random 10 questions to get the user a fresh set of questions. I had a little trouble with getting the True and False questions to only have two choices but I was able to solve this by simply hiding the other answer choices if I realized that the question was of True and False.

## License

    Copyright 2024 Samir Hassan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
