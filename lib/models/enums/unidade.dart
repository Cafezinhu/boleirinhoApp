enum Unidade { unidade, g, mL }

extension UnidadeExtension on Unidade {
  String stringfy() {
    return this.toString().split(".").last;
  }

  static Unidade fromString(String s) {
    for (Unidade unidade in Unidade.values) {
      if (unidade.stringfy() == s) {
        return unidade;
      }
    }
    return Unidade.unidade;
  }
}
