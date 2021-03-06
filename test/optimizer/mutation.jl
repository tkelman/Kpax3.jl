# This file is part of Kpax3. License is MIT.

# Pr(B1 = [1; 1; 1]) = 4 / 5
# Pr(B1 = [2; 1; 1]) = 1 / 5
#
# Pr(B2 = [1; 1; 1]) = (4 / 5) * (4 / 5) = 16 / 25
# Pr(B2 = [1; 2; 1]) = (4 / 5) * (1 / 5) = 4 / 25
# Pr(B2 = [2; 1; 1]) = (1 / 5) * (4 / 5) = 4 / 25
# Pr(B2 = [2; 2; 1]) = (1 / 5) * (1 / 5) * (1 / 2) = 1 / 50
# Pr(B2 = [2; 3; 1]) = (1 / 5) * (1 / 5) * (1 / 2) = 1 / 50
#
# Pr(B3 = [1; 1; 1]) = (4 / 5) * (4 / 5) * (4 / 5) = 64 / 125
# Pr(B3 = [1; 1; 2]) = (4 / 5) * (4 / 5) * (1 / 5) = 16 / 125
# Pr(B3 = [1; 2; 1]) = (4 / 5) * (1 / 5) * (4 / 5) = 16 / 125
# Pr(B3 = [1; 2; 2]) = (4 / 5) * (1 / 5) * (1 / 5) * (1 / 2) = 2 / 125
# Pr(B3 = [1; 2; 3]) = (4 / 5) * (1 / 5) * (1 / 5) * (1 / 2) = 2 / 125
# Pr(B3 = [2; 1; 1]) = (1 / 5) * (4 / 5) * (4 / 5) = 16 / 125
# Pr(B3 = [2; 1; 2]) = (1 / 5) * (4 / 5) * (1 / 5) * (1 / 2) = 2 / 125
# Pr(B3 = [2; 1; 3]) = (1 / 5) * (4 / 5) * (1 / 5) * (1 / 2) = 2 / 125
# Pr(B3 = [2; 2; 1]) = (1 / 5) * (1 / 5) * (1 / 2) * (4 / 5) = 2 / 125
# Pr(B3 = [2; 2; 2]) = (1 / 5) * (1 / 5) * (1 / 2) * (1 / 5) * (1 / 2) = 1/500
# Pr(B3 = [2; 2; 3]) = (1 / 5) * (1 / 5) * (1 / 2) * (1 / 5) * (1 / 2) = 1/500
# Pr(B3 = [2; 3; 1]) = (1 / 5) * (1 / 5) * (1 / 2) * (4 / 5) = 2 / 125
# Pr(B3 = [2; 3; 2]) = (1 / 5) * (1 / 5) * (1 / 2) * (1 / 5) * (1 / 2) = 1/500
# Pr(B3 = [2; 3; 3]) = (1 / 5) * (1 / 5) * (1 / 2) * (1 / 5) * (1 / 2) = 1/500

function test_mutation()
  R = [1; 1; 1]
  v = [3; 0; 0]

  o = Kpax3.KOffspring(copy(R), copy(v))

  mrate = 1 / 5

  N = 1000000

  pr = [64 / 125; 16 / 125; 16 / 125; 2 / 125; 2 / 125; 16 / 125; 2 / 125; 2 / 125;  2 / 125;  1 / 500; 1 / 500; 2 / 125;  1 / 500; 1 / 500]

  tmp = zeros(Float64, length(pr))

  for i in 1:N
    copy!(o.R, R)
    copy!(o.v, v)

    Kpax3.mutation!(o, mrate)

    if o.R == [1; 1; 1]
      @test o.v == [3; 0; 0]
      tmp[ 1] += 1
    elseif o.R == [1; 1; 2]
      @test o.v == [2; 1; 0]
      tmp[ 2] += 1
    elseif o.R == [1; 2; 1]
      @test o.v == [2; 1; 0]
      tmp[ 3] += 1
    elseif o.R == [1; 2; 2]
      @test o.v == [1; 2; 0]
      tmp[ 4] += 1
    elseif o.R == [1; 2; 3]
      @test o.v == [1; 1; 1]
      tmp[ 5] += 1
    elseif o.R == [2; 1; 1]
      @test o.v == [2; 1; 0]
      tmp[ 6] += 1
    elseif o.R == [2; 1; 2]
      @test o.v == [1; 2; 0]
      tmp[ 7] += 1
    elseif o.R == [2; 1; 3]
      @test o.v == [1; 1; 1]
      tmp[ 8] += 1
    elseif o.R == [2; 2; 1]
      @test o.v == [1; 2; 0]
      tmp[ 9] += 1
    elseif o.R == [2; 2; 2]
      @test o.v == [0; 3; 0]
      tmp[10] += 1
    elseif o.R == [2; 2; 3]
      @test o.v == [0; 2; 1]
      tmp[11] += 1
    elseif o.R == [2; 3; 1]
      @test o.v == [1; 1; 1]
      tmp[12] += 1
    elseif o.R == [2; 3; 2]
      @test o.v == [0; 2; 1]
      tmp[13] += 1
    elseif o.R == [2; 3; 3]
      @test o.v == [0; 1; 2]
      tmp[14] += 1
    end
  end

  tmp /= N

  @test isapprox(tmp, pr, rtol=0.01)

  nothing
end

test_mutation()
