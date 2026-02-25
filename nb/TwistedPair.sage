# ---
# jupyter:
#   jupytext:
#     formats: ipynb,sage:light
#     text_representation:
#       extension: .sage
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.18.1
#   kernelspec:
#     display_name: SageMath 10.8
#     language: sage
#     name: sagemath
# ---

# + [markdown] editable=true slideshow={"slide_type": ""}
# # The Twisted Pair Construction
# -

# ## Introduction
#
# $$
# \DeclareMathOperator{\psl}{PSL}
# \newcommand{\pslc}{\psl_2(\mathbb{C})}
# $$
#
# This notebook develops the math behind the "twisted pair" fractal.
# Only the $m=13, n=8$ case will be considered.
#
# There are two goals:
# 1. Define the generators of the twisted pair group in $\pslc$.
# 2. Find a permutation representation of the group with relatively few colors.

# ## Definition
# ### The Fundamental Polynomial
#
# Let $m$ and $n$ be two integers. In this discussion, we will use
# $m=13$ and $n=8$. Much of the algebra and analysis below is specific to this choice of parameters,
# so a lot of care is needed when attempting to generalize.

m = 13
n = 8

# The _twisted pair polynomial_ $\operatorname{TP}(x)$ is
# defined as
#
# $$
# \operatorname{TP}(x) = \frac{(2T_m(x/2) - 1)(2T_n(x/2) - 1) - 1}{x-2},
# $$
#
# where $T_n(x)$ is the Chebyshev polynomial of the first kind, satisfying $2T_n(\frac12(x + x^{-1})) = \frac12(x^n + x^{-n})$.

# +
# Polynomial ring over rationals.
Qx.<x> = QQ[]

# Some tools for constructing polynomials.
# Here are some useful primitives for constructing rational functions.
# Note that:
#   T(n, sp(x)/2) = sp(x^n)/2
#   U(n, sp(x)/2) = sn(x^(n+1))/sn(x)
T = chebyshev_T
U = chebyshev_U

def sp(x):
    return x + 1/x

def sn(x):
    return x - 1/x

Tm = 2*T(m, x/2)
Tn = 2*T(n, x/2)

# The twisted pair polynomial.
TP1 = Qx(((Tm - 1)*(Tn - 1) - 1)/(x - 2))

pretty_print(TP1)
# -

# Under certain conditions, this polynomial is irreducible over the rational numbers,
# and this is the case for the $m$ and $n$ we have chosen.
# In that case, the polynomial has degree $m+n-1$, which is 20 for us.

# ### The Twisted Pair Group
#
# The _twisted pair group_ is defined up to conjugacy
# as a subgroup of $\pslc$
# via its two generators $u$ and $r$, where
# $$
#   r = \begin{pmatrix}
#     0 & -1 \\
#     1 & 1
#   \end{pmatrix},\quad
#   ru = \begin{pmatrix}
#     0 & -\beta \\
#     1/\beta & \displaystyle\frac{\beta^{1+n} - \beta^{-1-n}}{\beta^n - \beta^{-n}}
#   \end{pmatrix}.
# $$
# Here,
# $$\beta = \frac12\left(\sqrt{\rho + 2} + \sqrt{\rho - 2}\right),$$
# where $\rho$ is a specially chosen root of the twisted pair polynomial
# that satisfies
# $$
# n\log(\beta^{2m}) + m\log(\beta^{-2n}) = 2\pi i
# $$
# using the principal branch of the logarithm.
# Moreover, we should find that $$\log(\beta^{-2n})/\log(\beta^{2m})\approx i.$$
#
# As stated, this definition defines the twisted pair group up to conjugacy in $\pslc$,
# and we'll refer to this specific choice of generators as the _canonical embedding_.

# ## Finite Colorings
#
# The coloring scheme works like this:
# 1. A finite number of colors are chosen.
# 2. Geometric entities of a certain type are assigned colors from the finite set.
#    "Geometric entities" here are a set of shapes that is closed under the action of the group
#    and meaningful in the context of the fractal being rendered.
# 4. The **structure rule:** the action of the group must permute the colors in a well defined way,
#    so if we ignore the geometry and just look at what's happening to the colors, we get a
#    finite permutation representation of the group.
#
# The structure rule just provides a mathematical significance to the choice of colors,
# bridging the aesthetics to the underlying structure.
# Obviously this rule isn't the only way to do that,
# but it is the approach chosen here.
#
# Suppose we have any embedding of the group into $\psl_2(K)$
# for any number field $K$.
# Note that since $\beta$ is algebraic, this is definitely the case for the canonical embedding given
# above with $K=\mathbb{Q}(\beta)$, so solutions definitely exist.
# In the ring of integers $\mathfrak{o}_K$ of $K$,
# all but finitely many prime ideals do not divide the
# denominators of any of the matrix entries.
# We can select any one of these non-exceptional prime ideals $\mathfrak{p}$ and reduce the entire matrix group
# modulo $\mathfrak{p}$.
# (The condition of $\mathfrak{p}$ not dividing any of the denominators guarantees that this can be
# done in a well-defined way.)
# This immediately gives us a finite permutation representation of the twisted pair group,
# namely on the projective line $\mathbf{P}^1(\mathfrak{o}_K/\mathfrak{p})$ of the finite field
# $\mathfrak{o}_K/\mathfrak{p}$.
#
# There are many possible choices of number field $K$, and then infinitely many choices of prime $\mathfrak{p}$.
# What makes one choice better than another?
# Well, we have to choose one color for each element of the acted-on set $\mathbf{P}^1(\mathfrak{o}_K/\mathfrak{p})$,
# which has cardinality $1 + \mathbf{N}\mathfrak{p}$.
# It's easier to work with fewer colors, so this suggests we should minimize the norm
# $\mathbf{N}\mathfrak{p}$ of the prime ideal.
# We'll adopt this strategy here.
#
# We'll make one final simplification in this approach: we'll only consider trace-preserving embeddings.
# In general, an algebraic isomorphism between subgroups of $\pslc$ need not preserve
# matrix traces,
# but trace-preserving isomorphisms are exactly the ones that are induced by inner automorphisms of
# $\pslc$, up to a single choice of sign.
# So in effect, we're restricting our attention to _geometry-preserving_ embeddings of the group as
# given by the canonical embedding above,
# since the set of conformal diffeomorphisms of $\mathbf{P}^1\mathbb{C}$ to itself is exactly
# $\pslc$.

# ### Minimal-Degree Embeddings
# #### A Lower Bound: the Trace Field
#
# We can see by inspection that the traces of $r$, $ur$, and $u$ are all
# rational functions of $\tau = \beta + \beta^{-1} = \sqrt{\rho + 2}$:
# $$
# \begin{align*}
# \operatorname{tr}(r) &= 1, \\
# \operatorname{tr}(u) &= \beta + \beta^{-1} = \tau, \\
# \operatorname{tr}(ru) &= \frac{\beta^{1+n} - \beta^{-1-n}}{\beta^n - \beta^{-n}} = \frac{U_n(\tau/2)}{U_{n-1}(\tau/2)},
# \end{align*}
# $$
# where $U_n$ is the Chebyshev polynomial of the second kind, with $U_n(\frac12(x + x^{-1})) = (x^{n+1} - x^{-n-1})/(x - x^{-1})$.
#
# It is a classically known result that
# the trace of every element in the subgroup of $\pslc$
# generated by $r$ and $u$ is a
# polynomial in $\operatorname{tr}(r)$, $\operatorname{tr}(u)$, and $\operatorname{tr}(ru)$ with integer coefficients.
# The smallest field containing the traces of everything in the group is thus
# $$
# K_1 = \mathbb{Q}(\tau) = \mathbb{Q}(\sqrt{\rho + 2}),
# $$
# and any field $K$ with an embedding of the twisted pair group into $\psl_2(K)$ must
# extend this field $K_1$.
# Also, any prime ideal $\mathfrak{p}$ of $K$ lies above some prime $\mathfrak{p}_1$ of $K_1$,
# and the quotient field $\mathfrak{o}_{K}/\mathfrak{p}$ is an extension of
# $\mathfrak{o}_{K_1}/\mathfrak{p}_1$,
# and thus the former has cardinality no smaller than the latter.
# Thus, if we want to minimize the norm of the prime ideal $\mathfrak{p}$,
# we can't do better than the smallest-norm primes in $K_1$:

# Since TP1(x) is the minimal polynomial of rho,
# TP1(x^2 - 2) is the minimal polynomial of tau = sqrt(rho + 2).
K1.<tau> = NumberField(Qx(TP1(x^2 - 2)))
K1.ideals_of_bdd_norm(16)

# Thus, the best we can do is a residue field of order 16.
# But is this lower bound attainable?
# We can see that the canonical embedding embeds into $\operatorname{PSL}_2(K)$
# with $K = \mathbb{Q}(\beta)$,
# but not with $K = K_1 = \mathbb{Q}(\tau)$.
# Can we in fact find a better embedding of the group into the latter?
# Minimizing the extension degree of the field $K$ is definitely interesting from the standpoint of mathematical simplicity and elegance.

# #### Ruling Out the Trace Field
#
# Suppose we have a two-generator group, possibly infinite (like the twisted pair group),
# with generators $a$ and $b$.
# Suppose we want to embed this group into $\psl_2(F)$ for some field
# $F$, and we know what the traces of the generators and their product
# need to be:
# $$\begin{align*}
# tr(a) &= A, \\
# tr(b) &= B, \text{ and}\\
# tr(ab) &= C,
# \end{align*}
# $$
# where $A$, $B$, and $C$ are all elements of $F$. Then an embedding exists if and only if
# this three-variable quadratic equation, which we'll call the
# *characteristic quadratic*,
# has a nontrivial solution $(u, v, w)\in F^3$:
# $$
# u^2 + v^2 + w^2 + Avw + Bwu + Cuv = 0.
# $$
# I assume this fact must have been known classically, but I wasn't able to find a reference for it.
# In any case, the proof is elementary, and we won't digress into it here.
#
# For the twisted pair generators, we have $A = 1$, $B = \sqrt{\rho + 2}$,
# and $C = U_{n}(\sqrt{\rho + 2}/2)/U_{n-1}(\sqrt{\rho + 2}/2)$,
# where $\rho$ is a root of the twisted pair polynomial, so the characteristic quadratic is
# $$
# u^2 + v^2 + w^2 + vw + \sqrt{\rho + 2}\,\, wu + \frac{U_{n}(\sqrt{\rho + 2}/2)}{U_{n-1}(\sqrt{\rho + 2}/2)}uv = 0.
# $$
# In order for the group to embed over any field $K$ with the correct traces,
# this equation must have a nontrivial solution $(u, v, w)\in K^3$.
#
# To further analyze this equation, let's observe that
# if one embedding of $\mathbb{Q}(\sqrt{\rho + 2})$ into $\mathbb{C}$ has a nontrivial solution,
# then all of them do.
# If some root $\rho$ is additionally real and larger than $-2$,
# then $\mathbb{Q}(\sqrt{\rho + 2})$ is in fact a subfield of $\mathbb{R}$,
# and thus the characteristic quadratic has a nontrivial real solution.
# This occurs if and only if the matrix
# $$
# \begin{bmatrix}
# 1 & C/2 & B/2 \\
# C/2 & 1 & A/2 \\
# B/2 & A/2 & 1
# \end{bmatrix}
# $$
# is not positive definite.
#
# So, does the fundamental polynomial have real solutions?
# We can plot it and see that apparently there are:

complex_plot(
    TP1, (-2.2, 2.2), (-0.55, 0.55),
    plot_points=1024, cmap='tab20b', tiled=True
).show(aspect_ratio=1, figsize=(16, 4))

# We can now check all the real roots and see if that matrix is positive definite:

# +
R.<x> = QQbar[]
rs = R(TP1).roots()

for (rho_, _) in rs:
    if rho_ in RR and rho_ >= -2:
        print("real root: %f" % rho_)
        for t_ in [sqrt(rho_ + 2), -sqrt(rho_ + 2)]:
            s_ = U(n, t_/2)/U(n-1, t_/2)
            C = Matrix([[1, s_/2, t_/2], [s_/2, 1, 1/2], [t_/2, 1/2, 1]])
            print("  %s positive definite." % (
                  "IS" if C.is_positive_definite() else "IS NOT"))
# -

# This proves that there is no trace-preserving embedding of the twisted pair group into $\mathbb{Q}(\tau) = \mathbb{Q}(\sqrt{\rho + 2})$,
# and the best we can hope for is a quadratic extension of that field.
# There are many possible ways to get that, but we can see that $\mathbb{Q}(\beta)$ is such a solution,
# using the canonical embedding.
#
# Let's check its low-norm prime ideals:

K.<beta> = NumberField(Qx(TP1(sp(x^2)) * x^(2*(m + n - 1))))
K.ideals_of_bdd_norm(16)

# We already showed earlier that we can't hope for a prime ideal with norm less than 16,
# so this shows that the canonical embedding embeds over a field with lowest possible degree,
# and it has prime ideals with the lowest possible norm.
# Moreover, in the canonical embedding, we can show that entries of the generator matrices
# are all _algebraic integers_, meaning the denominators are all trivial and
# there are no exceptional primes we can't use.
#
# There are three numbers we need to check: $\beta$, $1/\beta$, and $(\beta^{1+n} - \beta^{-1-n})/(\beta^n - \beta^{-n})$.
# From its minimial polynomial, we can easily see that $\rho$ is an algebraic integer.
# We have $\beta^2 + \beta^{-2} = \rho$,
# which shows that both $\beta$ and $1/\beta$ are algebraic integers.
# We can check the last one,
# $(\beta^{1+n} - \beta^{-1-n})/(\beta^n - \beta^{-n})$,
# by direct computation:

pretty_print(denominator((beta^(1+n) - beta^(-1-n))/(beta^n - beta^(-n))))

# The denomiator is trivial, which makes it an algebraic integer.
# Thus, our canonical embedding has algebraic integer entries, which means we can use any prime ideal,
# including those norm-16 ideals.
# Of course, we could have checked all this without first proving that the field has minimal degree,
# but I think it's useful to know that the embedding itself is as simple as possible, in some sense.
#
# Thus, we'll accept the canonical embedding for what follows.

def twisted_pair_generators(beta):
    F = beta.parent()
    r = Matrix([[F(0), F(-1)], [F(1), F(1)]])
    ru = Matrix([[F(0), F(-beta)], [F(1/beta), F((beta^(n+1) - beta^(-1-n))/(beta^n - beta^-n))]])
    u = r.inverse() * ru
    return r, u, ru

# ## Permutation Representation

# If we take one of the order-16 fields found above, we get a representation
# of the twisted pair group in $\psl(2, 16)$,
# which can in turn be embedded as a subgroup of the symmetric group $S_{17}$.
#
# As a technical point, our group will act on row vectors, not column vectors.
# Thus, the acted-on elements will be on the left.

# +
F = K.ideal(2, beta^4 + beta + 1).residue_field()
P = ProjectiveSpace(1, F)
points = P.rational_points()
points_inv = P.rational_points_dictionary()

r_F, u_F, ru_F = twisted_pair_generators(F(beta))

G = PermutationGroup([r_F, u_F], action=(lambda g, a: points_inv[g.transpose()*points[a]]),
                     domain=range(len(points)),
                     canonicalize=False)
r_p, u_p = G.gens()
print("order: %d" % G.order())
print("r: %s" % r_p.cycle_string())
print("u: %s" % u_p.cycle_string())
print("ru: %s" % (r_p*u_p).cycle_string())
# -

# The order of $\psl(2, 16)$ itself is 4080,
# which means the permutation group we obtain here is $\psl(2, 16)$
# itself.

# ## Complex Embedding
#
# Recall that the "correct" fundamental polynomial root $\rho$ should satisfy
# $$
# \begin{align*}
# n\log(\beta^{2m}) + m\log(\beta^{-2n}) &= 2\pi i, \\
# \log(\beta^{-2n})/\log(\beta^{2m}) &\approx i.
# \end{align*}
# $$
#
# We already computed all the roots above, so we check them to see if one works:

# +
for (rho_, _) in rs:
    beta_ = (sqrt(rho_ + 2) + sqrt(rho_ - 2))/2
    g, h = beta_^(2*m), beta_^-(2*n)
    if abs((n*log(g) + m*log(h))/(2*pi*i) - 1) <= 1e-12:
        break
else:
    raise RuntimeError("no suitable root!")

print("rho: %s" % rho_)
print("beta: %s" % beta_)
print("g: %s" % g)
print("h: %s" % h)
print("g trace: %s" % N(sqrt(g) + 1/sqrt(g)))
print("effective exponent: %s" % N(log(h)/log(g)))
# -

# ## Geometric Entities
#
# Recall that we're supposed to assign colors to "geometric entities."
# $u$ has two fixed points, and so does its corresponding permutation.
# We can thus draw a correspondence between these two pairs of points
# and extend it to the rest of the orbit of these fixed points under the group action.
# (The choice between the two possible bijections here doesn't matter, and they're
# equivalent under an inner automorphism.)
#
# In other words, the geometric entities are points, or more precisely the orbit
# of a fixed point of $u$ under the action of the twisted pair group.
#
# This orbit is dense in the Riemann sphere, so to make the result visually parseable,
# there needs to be a mechanism to spread or average colors around nearby points.
# That's a purely aesthetic concern, and we don't place any mathematical constraints on it here.
