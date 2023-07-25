describe Cl, 'opts' do
  let!(:const) { Class.new(Cl::Cmd, &opts).register(:cmd) }

  describe 'secret' do
    let(:opts) { ->(*) { opt('--str STR', secret: true) } }

    it { expect(const.opts.first.secret?).to be true }
    it { expect(cmd(%w(cmd --str str)).opts[:str]).to eq 'str' }
  end
end
