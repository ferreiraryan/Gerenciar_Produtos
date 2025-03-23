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
    if (_quantidadeEmEstoque >= quantidade) {
      _vendidos += quantidade;
      return true;
    } else {
      print("Estoque insuficiente para o produto ${_nome}.");
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
  // Utiliza um Map para associar cada produto à quantidade no carrinho.
  Map<Produto, int> carrinho = {};

  // Adiciona o produto no carrinho e controla a quantidade
  void adicionarProdutoNoCarrinho(Produto produto, int quantidade) {
    if (produto.quantidadeEmEstoque < quantidade) {
      print("Estoque indisponível para o produto ${produto.nome}!");
      return;
    }

    // Usa o operador ?? para somar a quantidade, se já existir, ou definir 0 caso contrário
    carrinho[produto] = (carrinho[produto] ?? 0) + quantidade;

    produto.reduzirEstoque(quantidade);
    print("Produto ${produto.nome} adicionado ao carrinho!");
  }

  // Exibe os produtos no carrinho
  void mostrarCarrinho() {
    if (carrinho.isEmpty) {
      print("Carrinho vazio!");
      return;
    }

    double precoTotal = 0;
    carrinho.forEach((produto, quantidade) {
      precoTotal += produto.preco * quantidade;
      print("------");
      print("${produto.nome} - R\$ ${produto.preco} x $quantidade");
    });

    print("*****");
    print("Preço total: R\$ $precoTotal");
  }

  // Realiza a compra dos itens do carrinho
  void comprarCarrinho() {
    if (carrinho.isEmpty) {
      print("Adicione algum produto ao carrinho para comprar!");
      return;
    }

    List<Produto> itensParaRemover = [];

    carrinho.forEach((produto, quantidade) {
      if (!produto.vender(quantidade)) {
        return;
      }
      itensParaRemover.add(produto);
    });

    // Após a compra, remove os produtos vendidos do carrinho
    for (var produto in itensParaRemover) {
      carrinho.remove(produto);
    }

    print("Compra realizada com sucesso!");
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
    int vendidos = element.vendidos;
    print(
      " - $nomeProduto, R\$ $precoProduto, Quantidade: $quantProduto, Vendidos: $vendidos",
    );
  }
}

void selecionarProdutoParaCarrinho() {
  if (produtos.isEmpty) {
    print("Não existe nenhum produto cadastrado!");
    return;
  }
  print("---------");
  listarProdutos();

  print("Digite o nome do produto que quer adicionar ao carrinho:");
  String nomeProduto = entradaString();

  bool produtoEncontrado = false;
  for (var element in produtos) {
    if (element.nome == nomeProduto) {
      produtoEncontrado = true;
      print("Digite a quantidade desejada:");
      int quantidadeProduto = int.parse(entradaString());
      carrinho.adicionarProdutoNoCarrinho(element, quantidadeProduto);
      break;
    }
  }
  if (!produtoEncontrado) {
    print("Produto não encontrado!");
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
      case "X":
      case "x":
        break;
      case "A":
      case "a":
        selecionarProdutoParaCarrinho();
        break;
      case "L":
      case "l":
        carrinho.mostrarCarrinho();
        break;
      case "C":
      case "c":
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
      case "X":
      case "x":
        break;
      case "C":
      case "c":
        produtos.add(cadastrarProdutos());
        break;
      case "L":
      case "l":
        listarProdutos();
        break;
      case "M":
      case "m":
        loopCarrinho();
        break;
    }
  }
}

void main(List<String> arguments) {
  loopMain();
}
