--[[
** find rational approximation to given real number
** David Eppstein / UC Irvine / 8 Aug 1993
**
** With corrections from Arno Formella, May 2008
**
** usage: a.out r d
**   r is real number to approx
**   d is the maximum denominator allowed
**
** based on the theory of continued fractions
** if x = a1 + 1/(a2 + 1/(a3 + 1/(a4 + ...)))
** then best approximation is found by truncating this series
** (with some adjustments in the last term).
**
** Note the fraction can be recovered as the first column of the matrix
**  ( a1 1 ) ( a2 1 ) ( a3 1 ) ...
**  ( 1  0 ) ( 1  0 ) ( 1  0 )
** Instead of keeping the sequence of continued fraction terms,
** we just keep the last partial product of these matrices.
--]]
-- See https://stackoverflow.com/a/96035/3697584 and http://www.ics.uci.edu/~eppstein/numth/frap.c

local floor = math.floor

local function toFraction(startx, maxden)
   maxden = maxden or 10000
   local m = {[0]={[0]=1,0}, {[0]=0,1}}
   local x = startx
   local ai = 0

   local function setAi(val) ai = val return val end

   -- loop finding terms until denom gets too big
   while m[1][0] * setAi(floor(x)) + m[1][1] <= maxden do
      local t
      t = m[0][0] * ai + m[0][1]
      m[0][1] = m[0][0]
      m[0][0] = t
      t = m[1][0] * ai + m[1][1]
      m[1][1] = m[1][0]
      m[1][0] = t
      if x == ai/1 then
         break -- AF: division by zero
      end
      x = 1/(x - ai)
      if x > 0x7FFFFFFF then
         break  -- AF: representation failure
      end
   end

   -- now remaining x is between 0 and 1/ai approx as either 0 or 1/m
   -- where m is max that will fit in maxden first try zero
   local r0, r1 = m[0][0], m[1][0]
   local err0 = startx - m[0][0] / m[1][0]

   -- now try other possibility
   ai = (maxden - m[1][1]) / m[1][0]
   m[0][0] = m[0][0] * ai + m[0][1]
   m[1][0] = m[1][0] * ai + m[1][1]
   local err1 = startx - m[0][0] / m[1][0]
   if err0 <= math.abs(err1) then
      -- print("ERRS", err0, err1)
      return r0, r1, err0
   end
   -- else
   return floor(m[0][0]), floor(m[1][0]), err1
end

return toFraction

