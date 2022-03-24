[![Gem Version](https://badge.fury.io/rb/rggen-verilog.svg)](https://badge.fury.io/rb/rggen-verilog)
[![CI](https://github.com/rggen/rggen-verilog/workflows/CI/badge.svg)](https://github.com/rggen/rggen-verilog/actions?query=workflow%3ACI)
[![Maintainability](https://api.codeclimate.com/v1/badges/7a4090f4a7c21d29036c/maintainability)](https://codeclimate.com/github/rggen/rggen-verilog/maintainability)
[![codecov](https://codecov.io/gh/rggen/rggen-verilog/branch/master/graph/badge.svg)](https://codecov.io/gh/rggen/rggen-verilog)
[![Gitter](https://badges.gitter.im/rggen/rggen.svg)](https://gitter.im/rggen/rggen?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# RgGen::Verilog

RgGen::Verilog is a RgGen plugin to generate RTL written in Verilog.

## Installation

To install RgGen::Verilog, use the following command:

```
$ gem install rggen-verilog
```

## Usage

You need to tell RgGen to load RgGen::Verilog plugin. There are two ways.

### Using `--plugin` runtime option

```
$ rggen --plugin rggen-verilog your_register_map.yml
```

### Using `RGGEN_PLUGINS` environment variable

```
$ export RGGEN_PLUGINS=${RGGEN_PLUGINS}:rggen-verilog
$ rggen your_register_map.yml
```

## Using Generated RTL

Generated RTL files are constructed by using common Verilog modules.
You need to get them from GitHub repository and set an environment variable to show their location.

* GitHub repository
    * https://github.com/rggen/rggen-verilog-rtl.git
* Environment Variable
    * RGGEN_VERILOG_RTL_ROOT

```
$ git clone https://github.com/rggen/rggen-verilog-rtl.git
$ export RGGEN_VERILOG_RTL_ROOT=`pwd`/rggen-verilog-rtl
```

Then, you can use generated RTL files with your deisgn. This is an example command.

```
$ simulator \
    -f ${RGGEN_VERILOG_RTL_ROOT}/compile.f
    your_csr_0.v your_csr_1.v your_design.v
```

## Contact

Feedbacks, bus reports, questions and etc. are welcome! You can post them bu using following ways:

* [GitHub Issue Tracker](https://github.com/rggen/rggen-verilog/issues)
* [Chat Room](https://gitter.im/rggen/rggen)
* [Mailing List](https://groups.google.com/d/forum/rggen)
* [Mail](mailto:rggen@googlegroups.com)

## Copyright & License

Copyright &copy; 2020-2022 Taichi Ishitani. RgGen::Verilog is licensed under the [MIT License](https://opensource.org/licenses/MIT), see [LICENSE](LICENSE) for futher details.

## Code of Conduct

Everyone interacting in the RgGen::Verilog project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rggen/rggen-verilog/blob/master/CODE_OF_CONDUCT.md).
