import SwiftUI

struct ContentView: View {
    @State private var anos: String = ""
    @State private var idadeCanina: String = ""
    @State private var limpartext: String = "Limpar"
    
    
    func calcularIdadeCanina(anos: Int) {
        let idade = anos * 7
        idadeCanina = "A idade canina é: \(idade) anos."
    }
    

    func limparCampos() {
        idadeCanina = ""
        anos = ""
        limpartext = "Limpar"
    }
    
    var inputEValido: Bool {
        return !anos.isEmpty && Int(anos) != nil
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Calculadora de idade canina!")
                .font(.title)
                .padding()
            
            TextField(
                "Digite a idade canina",
                text: $anos
            )
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(8)
                
            Button(action: {
                if let anosInt = Int(anos) {
                    calcularIdadeCanina(anos: anosInt)
                } else {
                    idadeCanina = "Por favor, insira um número válido."
                }
            }) {
                Text("Calcular")
                    .padding()
                    .background(inputEValido ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!inputEValido)

            Text(idadeCanina)
                .padding()

            Button(action: {
                limparCampos()
            }) {
                Text(limpartext)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
        )
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
