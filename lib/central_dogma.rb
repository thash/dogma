require "central_dogma/version"

module CentralDogma
  module NucreicAcid
    class A; def complementary; T.new; end; end
    class T; def complementary; A.new; end; end
    class U; def complementary; A.new; end; end
    class G; def complementary; C.new; end; end
    class C; def complementary; G.new; end; end
  end

  # DNA
  class DNA
    include NucreicAcid

    attr_reader :array

    class Chain
      attr_reader :direction
      def initialize(from, to)
        @array = []
        @direction = if [from, to] == [3, 5]
                       :_3to5
                     elsif [from, to] == [5, 3]
                       :_3to5
                     end
      end

      def complementary
        @array.map{|base| base.complementary }
      end
    end

    def initialize(str)
      @array = str.each_char.map{|char| eval(char.capitalize).new }
    end

    def self.bases
      [A, T, G, C]
    end

    def self.build_from_pair(chain_3to5, chain_5to3)
      new #TODO
    end

    def dna?; true; end
    def transcript
      @rna ||= RNA.new(self)
    end
    alias :to_rna :transcript

    def chain_5to3
      @chain_5to3 ||= Chain.new
    end

    def chain_3to5
      @chain_3to5 ||= Chain.new
    end

    def replicate
      [self, self.class.build_from_pair(self.chain_3to5.complementary, self.chain_5to3.complementary)]
    end
  end

  class RNA
    include NucreicAcid

    attr_reader :role

    def self.bases
      [A, U, G, C]
    end

    def initialize(dna)
      @role = :messenger if true # judge if messenger
      @array = dna.array.map{|base| base.is_a?(A) ? U.new : base.complementary }
    end

    def rna?; true; end
    def messenger?; @role == :messenger; end

    def translate
      return false unless messenger?
      @protein ||= Protein.new(self)
    end
    alias :to_protein :translate

    def replicate
      # TODO: RNA replication. +/- sense
    end

  end

  class Protein
    def initialize(mrna)
    end
  end
end
