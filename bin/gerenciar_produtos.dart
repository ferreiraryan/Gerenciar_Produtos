import 'dart:ffi';
import 'dart:io';

List<Produto> produtos = [];
Carrinho carrinho = Carrinho();

class Produto {
  String _nome;
  double _preco;
  int _quantidadeEmEstoque;
  String? _descricao;
  int _vendidos = 0;

  Produto(
    this._nome,
    this._preco,
    this._quantidadeEmEstoque, [
    this._descricao,
  ]);
  String get nome => _nome;
  double get preco => _preco;
  int get quantidadeEmEstoque => _quantidadeEmEstoque;
  int get vendidos => _vendidos;

  set nome(String nome) {
    if (nome.isNotEmpty) {
      _nome = nome;
    } else {
      print('Nome não pode ser vazio');
    }
  }

  set preco(double preco) {
    if (preco > 0) {
      _preco = preco;
    } else {
      print('Preço deve ser maior que 0');
    }
  }

  set quantidadeEmEstoque(int quantidade) {
    if (quantidade >= 0) {
      _quantidadeEmEstoque = quantidade;
    } else {
      print('Quantidade em estoque não pode ser negativa');
    }
  }

  set descricao(String? descricao) {
    _descricao = descricao;
  }

  set vendidos(int quantidade) {
    if (quantidade >= 0) {
      _vendidos = quantidade;
    } else {
      print('Quantidade vendida não pode ser negativa');
    }
  }

  bool vender(int quantidade) {
    if (_quantidadeEmEstoque > 0) {
      _vendidos += quantidade;
      return true;
    } else {
      return false;
    }
  }

  bool reduzirEstoque(int quantidade) {
    if (_quantidadeEmEstoque < 0) {
      return false;
    }
    _quantidadeEmEstoque -= quantidade;
    return true;
  }

  void reporEstoque(int quantidade) {
    if (quantidade > 0) {
      _quantidadeEmEstoque += quantidade;
    }
  }
}

class Carrinho {
  List<Produto> carrinho = [];

  void adicionarProdutoCarrinho(Produto produto) {
    carrinho.add(produto);
    produto.reduzirEstoque(1);
  }

  void mostrarCarrinho() {
    if (carrinho.isEmpty) {
      print("carrinho vazio!");
      return;
    }
    double precototal = 0;
    for (var produto in carrinho) {
      String nome = produto.nome;
      double preco = produto.preco;
      precototal += preco;
      print("------");
      print("$nome - R\$ $preco");
    }
    print("*****");
    print("Preço total: $precototal");
  }

  void comprarCarrinho() {
    List<Produto> itensParaRemover = [];

    for (var produto in carrinho) {
      if (produto.vender(1)) {
        print("Compra realizada do produto ${produto.nome}");
        itensParaRemover.add(produto);
      } else {
        print("Estoque indisponível para o produto ${produto.nome}!");
      }
    }

    carrinho.removeWhere((produto) => itensParaRemover.contains(produto));
  }
}

String entradaString() {
  String? entrada;
  do {
    entrada = stdin.readLineSync();
  } while (entrada == null);

  return entrada;
}

Produto cadastrarProdutos() {
  print("Digite o nome:");
  String nome = entradaString();
  print("Digite o preço:");
  double preco = double.parse(entradaString());
  print("Digite a quantidade em estoque:");
  int quantEstoque = int.parse(entradaString());
  print("Digite a descrição ou deixe em branco:");
  String descricao = entradaString();
  if (descricao != "") {
    return Produto(nome, preco, quantEstoque, descricao);
  }
  return Produto(nome, preco, quantEstoque);
}

void listarProdutos() {
  print("-----------");
  for (var element in produtos) {
    String nomeProduto = element.nome;
    double precoProduto = element.preco;
    int quantProduto = element.quantidadeEmEstoque;
    int Vendidos = element.vendidos;
    print(
      " - $nomeProduto, R\$ $precoProduto, Quantidade: $quantProduto, Vendidos: $Vendidos",
    );
  }
}

void loopCarrinho() {
  String? entrada = "";
  while (entrada != "x" && entrada != "X") {
    print("-----------");
    print("X - Sair do carrinho");
    print("a - Adicionar produto ao carrinho");
    print("L - Listar Produtos do carrinho");
    print("c - Comprar carrinho");
    entrada = entradaString();
    switch (entrada) {
      case "X" || "x":
        break;
      case "A" || "a":
        print("---------");
        listarProdutos();
        print("Digite o nome do produto que quer adicionar ao carrinho:");
        String nomeProduto = entradaString();
        print("Digite a quantidade desejada:");
        for (var element in produtos) {
          if (element.nome != nomeProduto) {
            print("Produto nao encontrado!");
          } else {
            carrinho.adicionarProdutoCarrinho(element);
          }
        }
        break;
      case "L" || "l":
        carrinho.mostrarCarrinho();
        break;
      case "C" || "c":
        carrinho.comprarCarrinho();
        break;
    }
  }
}

void loopMain() {
  String? entrada = "";
  while (entrada != "x" && entrada != "X") {
    print("-----------");
    print("X - Sair");
    print("C - Cadastrar produto");
    print("L - Listar Produtos");
    print("M - Carrinho");
    entrada = entradaString();
    switch (entrada) {
      case "X" || "x":
        break;
      case "C" || "c":
        produtos.add(cadastrarProdutos());
        break;
      case "L" || "l":
        listarProdutos();
        break;
      case "M" || "m":
        loopCarrinho();
        break;
    }
  }
}

void main(List<String> arguments) {
  loopMain();
}
