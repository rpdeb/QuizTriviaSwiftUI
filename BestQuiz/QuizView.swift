import SwiftUI

struct QuizView: View {
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var quizStarted = false
    @State private var score = 0

    let questions = [
        Question(text: "Qual é a capital da França?", options: ["Paris", "Londres", "Berlim", "Madrid"], correctAnswerIndex: 0),
        Question(text: "Qual é o maior planeta do nosso sistema solar?", options: ["Terra", "Júpiter", "Marte", "Vênus"], correctAnswerIndex: 1),
        Question(text: "Quem escreveu 'Romeu e Julieta'?", options: ["Charles Dickens", "Jane Austen", "William Shakespeare", "F. Scott Fitzgerald"], correctAnswerIndex: 2),
    ]

    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }

    var bindingSelectedAnswerIndex: Binding<Int?> {
        Binding(
            get: { selectedAnswerIndex },
            set: { newValue in
                selectedAnswerIndex = newValue
            }
        )
    }

    var body: some View {
        VStack {
            if !quizStarted {
                Text("Iniciar Quiz")
                    .font(.title)
                    .padding()
                Button(action: {
                    quizStarted = true
                    score = 0
                    currentQuestionIndex = 0
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.blue)
                }
            } else if currentQuestionIndex < questions.count {
                Text("Pergunta \(currentQuestionIndex + 1) de \(questions.count)")
                    .padding()

                Text(currentQuestion.text)
                    .font(.title)
                    .padding()

                VStack(spacing: 20) { // Espaçamento vertical entre opções
                    ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                        Button(action: {
                            bindingSelectedAnswerIndex.wrappedValue = index
                        }) {
                            Text(currentQuestion.options[index])
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple) // Altere a cor para lilás
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .opacity(bindingSelectedAnswerIndex.wrappedValue == index ? 0.7 : 1.0)
                        }
                        .disabled(bindingSelectedAnswerIndex.wrappedValue != nil)
                    }
                }
                .padding() // Espaçamento nas bordas das opções

                Button(action: {
                    if let selectedAnswerIndex = bindingSelectedAnswerIndex.wrappedValue {
                        if selectedAnswerIndex == currentQuestion.correctAnswerIndex {
                            score += 1
                        }

                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                        } else {
                            // Última pergunta, marcar o quiz como concluído
                            quizStarted = false
                        }

                        bindingSelectedAnswerIndex.wrappedValue = nil
                    }
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding()
                .disabled(bindingSelectedAnswerIndex.wrappedValue == nil)
            } else {
                Text("Pontuação: \(score) de \(questions.count)")
                    .font(.title)
                    .padding()

                Button(action: {
                    quizStarted = false
                }) {
                    Text("Reiniciar Quiz")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct Question {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
