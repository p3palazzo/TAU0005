---
title: "Bibliografia"
date: 2021-07-20
---

# Livro-texto #

- {% reference ching:2016historia %}

<details>

  <summary>

  Como obter o e-book

  </summary>

  Acessar o site da [Biblioteca Central](https://bce.unb.br). Pesquisar
  pelo livro usando a `Busca integrada` (função de busca padrão da
  [BCE]{.smallcaps}). Na visualização do resultado, clicar no link
  <i class="fas fa-search" title="ícone de uma lupa"></i>
  `View record at Minha Biblioteca`. Fazer login no serviço de leitura online
  usando as credenciais da [BCE]{.smallcaps} ([CPF]{.smallcaps} e senha
  usada no balcão de empréstimo).

</details>

O livro-texto oferece um sobrevoo introdutório dos temas históricos
tratados ao longo do semestre. As páginas relevantes para cada tópico
estão indicadas no cronograma da disciplina.

# Manuais práticos de arquitetura clássica #

As duas obras indicadas abaixo são os pontos de partida mais indicados
para a elaboração dos trabalhos, e devem ser estudadas com afinco. Ambas
estão disponíveis na área de arquivos do [Microsoft Teams][].

- {% reference chitham:2005classical %}
- {% reference vitruvio:2007tratado %}

Há um grande número de edições e traduções do tratado de Vitrúvio,
produzidas desde o século [XV]{.smallcaps} até os dias de hoje. Algumas têm
ilustrações que facilitam a compreensão do texto, com destaque para a
tradução francesa de [Claude Perrault (1673)][] e a americana de [Morris
Morgan (1914)][].

# Básica #

A bibliografia básica representa um corpo de conhecimentos mínimo para
entender o conteúdo da disciplina, mas não esgota as referências
necessárias para realizar os trabalhos. A maior parte dos títulos
indicados está disponível em formato eletrônico no [catálogo da
[BCE]{.smallcaps}](https://bce.unb.br), ou nos links indicados.

```{=latex}
\nocite{*}

\printbibliography[keyword={tau0005-basica},heading=none]
```

```{=html}
{% bibliography --query @*[keywords=tau0005-basica] %}
```

# Complementar #

A bibliografia complementar oferece um aprofundamento opcional em
conteúdos mais específicos, bem como discussões teóricas relevantes para
a abordagem desta disciplina.

```{=latex}
\printbibliography[keyword={tau0005-complementar},heading=none]
```

```{=html}
{% bibliography --query @*[keywords=tau0005-complementar] %}
```

[[BCE]{.smallcaps}]: https://bce.unb.br

[Microsoft Teams]: https://teams.microsoft.com/l/team/19%3aUsJdAp730q1MDQwmuqPX1xrVCzihj-ZgM2WnodRSnmw1%40thread.tacv2/conversations?groupId=d022e11c-3e61-4d38-a5e3-e4e1e8590e32&tenantId=ec359ba1-630b-4d2b-b833-c8e6d48f8059

[Claude Perrault (1673)]: http://archive.org/details/gri_33125008503100

[Morris Morgan (1914)]: http://archive.org/details/vitruviusthetenbooksonarchitecture
