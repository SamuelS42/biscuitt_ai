import 'package:flutter/material.dart';
import 'services/openai_service.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  OpenAIService _service = OpenAIService();
  String _responseText = '';

  void _getResponse() async {
    try {
      String response = await _service.fetchResponse(
        "Based on the following lecture transcript, generate 5 multiple-choice questions: Okay, in terms of accidental creation, I think that these gestalt principles actually at times do pop up a bit more as something that has accidentally happened in your visualization that you may or may not be aware of. So we're going to talk about these next here. So, a bit of background, Gestalt, they're German psychologists, early 1900s, attempted to understand the concept of how people do pattern perception, founded a Gestalt School of Psychology, and a whole bunch of other sort of Gestalt principles that emerged from it. And we're going to talk through these. Overview first. Here's the list of them. Connectedness, we'll talk about slightly today. But as you can imagine, this comes up strongly when we talk about network and graph visualization. But in essence, what these principles do is they help us approximate what stands out visually, right, and a little bit of why. Although these are still theories at this point as to the why part, right? There are images of each of these and we're going to walk through each of them and talk about the perceptual science version of it, about sort of what it means and what it describes. And then we'll talk about a visualization that directly leverages each of them and have both pieces of that to go off. So the first one, we people group objects together that are proximate, right? The way that this was studied in the perceptual sciences is when people are asked, what do you see here? Right? More likely than not, statistically speaking, people say I see three pairs of squares. Right? They don't say two sets of three squares, right? Because why would you say that? And so on and so forth, right? Saying down here, right, when asked, they would say, I see one square filled with circles right here. They would say, I see three sets of circles in these two column format here. This is literally just the way that we just immediately perceive certain visuals like this. Now why is this particular one used in visualizations? We pretty basic chart that leverages this pretty strongly is a group bar chart, right? So the proximity of the grouping of these bars stands out in a bit of foreshadowing, actually overrides color in terms of how people perceive this, right? People are more likely to really be able to break apart the favorite color of children in preschool, primary school, secondary school based on the grouping or proximity principle being used here for this. And therefore, if what one is going for is that, that is the primary message that stands out in a visualization, is the juxtaposition between each of these. Then this is a good visual design that one should go for. Right? Okay, let's move on to the next one, Closure. It has been shown that people innately try to see collections of objects as creating a larger, more complete object. We create closure in shapes even when they are not explicitly closed, right? This here is perceived and described as a circle, even though it has breaks in this as a rectangle. Although it has breaks in it, right? Similar, There is a perceived phenomena here of a circle that is somehow underlying the smaller dots that are displayed in this way, right? We see the triangle, and the triangle that is the negative being shown up there as well as the black positive, right, even though it is not explicitly drawn there. Right? That's another one like that. We're talking about a couple here. And then we'll look at another sort of more advanced viz, example, similarity, right? We group similar objects together, right? So you can start to think about, well, similarity and proximity does grouping, right? Okay, The coloring here, even things like in typography, the upper case and lower case shape works pretty well for this kind of grouping. Color works pretty well for this kind of grouping. And other examples like that where this comes up in visualizations. Here's an example of a radial hierarchical chart. The way that it works here, right? We see similar objects because of color and actually because of location, right? But actually, color is overriding in this particular example because we actually see the hierarchy of design including things like brochures and banners, in this case different as SEO's public relation. Things for marketing in terms of total revenue split up hierarchically in this radial sunburst style visualization. Sometimes might even argue often in visualization we combine them either intentionally or unintentionally, right? I talked about this one here earlier. Right here, we're using colors and grouping actually and the group bar chart, right? So you might ask the question, which is dominant, right? People see collection of 4 bar, or do people see blue bars, four yellow bars, green, right? Is that the pre attentively dominant one? More often than not, grouping overrides color in this case.",
        maxTokens: 2000,
        temperature: 0.3,
        // topP: 0.5,
        // frequencyPenalty: -0.5,
        // presencePenalty: 0.5
      );
      setState(() {
        _responseText = response;
      });
    } catch (e) {
      // Handle the error as you see fit
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _getResponse,
          child: Text('Get Response from OpenAI'),
        ),
        Text(_responseText),
        Expanded(child: QuestionView()),
      ],
    );
  }
}

class QuestionView extends StatefulWidget {
  const QuestionView({Key? key}) : super(key: key);

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  String currentQuestionText = "Default Question";
  List<String> currentAnswerText = [
    "Default Answer A",
    "Default Answer B",
    "Default Answer C",
    "Default Answer D"
  ];

  void setQuestion(
      {required String newQuestionText, required List<String> newAnswerText}) {
    setState(() {
      currentQuestionText = newQuestionText;
      currentAnswerText = newAnswerText;
    });
  }

  void answerGuessed(int index) {
    //TODO: implement
    print("Answer #$index guessed: \"${currentAnswerText[index]}\"");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                currentQuestionText,
                style: Theme.of(context).textTheme.headline4, // assuming `headlineLarge` was a typo.
              ),
            ),
          ] +
          List.generate(
              currentAnswerText.length,
              (i) => Container(
                  padding: const EdgeInsets.all(50),
                  child: ElevatedButton(
                      onPressed: () => answerGuessed(i),
                      child: Text(currentAnswerText[i])))),
    );
  }
}
