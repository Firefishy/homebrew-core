class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/ec/45/b37d367fb6bb70ea24850bac1b182be9f79098c37fe548217ac0c1e85e81/awscli-1.27.140.tar.gz"
  sha256 "65de19b6bbb02f824c94ab77809533a975cf615277d83ff62cb5743f3888004a"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbdbc9f256ccbefe17887b76d7f406c73b83a52fe3dcc7ebfec56268db58243d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16ca818cafcc6fa25ce182bba66ac0fc7850cb1692cc6e3a49086a1cca890225"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e3b7e8c19b1b41e3da8da9244f3cb80ef0d35b65e42f48f07681f9c541153ec"
    sha256 cellar: :any_skip_relocation, ventura:        "54eaf2e680aac8afe527e672f2d1b342b727acf3ef5d0883febc85eb3997c96c"
    sha256 cellar: :any_skip_relocation, monterey:       "dcb2c3cc46a8e01da682f6d8bdfa6c7007d49598109c34dcf3b9e9bc524ca66b"
    sha256 cellar: :any_skip_relocation, big_sur:        "39a592f10d7d7dffe73842d462054d785909186d2ddc8872597d2f4536ee3dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84d14316e3107574b1abda281131df4e20e0bbe496b8dcb6cec3763ea45f98e"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/07/19/ea6e61c24f853471c5a5223a74d25992cdaf1db48e822b53573a27471dac/botocore-1.29.140.tar.gz"
    sha256 "a52ced1a0311178849e332c2c85c5b702adb30b68c5de66a5fd59488d19de65a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
