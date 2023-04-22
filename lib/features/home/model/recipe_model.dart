// To parse this JSON data, do
//
//     final recipeModel = recipeModelFromJson(jsonString);

import 'dart:convert';

RecipeModel recipeModelFromJson(String str) => RecipeModel.fromJson(json.decode(str));

String recipeModelToJson(RecipeModel data) => json.encode(data.toJson());

class RecipeModel {
    RecipeModel({
        required this.id,
        required this.name,
        required this.summary,
        required this.ingredients,
        required this.steps,
    });

    String id;
    String name;
    String summary;
    List<dynamic> ingredients;
    List<dynamic> steps;

    factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json["id"],
        name: json["name"],
        summary: json["summary"],
        ingredients: List<dynamic>.from(json["ingredients"].map((x) => x)),
        steps: List<dynamic>.from(json["steps"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "summary": summary,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
        "steps": List<dynamic>.from(steps.map((x) => x)),
    };
}
