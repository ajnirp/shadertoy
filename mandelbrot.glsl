// Multiply two complex numbers.
vec2 mult(vec2 a, vec2 b) {
	return vec2(a.x*b.x-a.y*b.y, a.y*b.x+a.x*b.y);
}

// Return # iterations it takes for the function to diverge.
// If it doesn't diverge return max_iter.
float iter(vec2 c, const int max_iter, const float divergence_threshold) {
	vec2 z = vec2(0.);
    int n = 0;
    while (length(z) <= 2. && n < max_iter) {
    	z = mult(z,z) + c;
        n++;
    }
    // Adapted from https://stackoverflow.com/a/1243788, but
    // I threw in another log because why not. The results are
    // entirely different than with just 2 log's.
    float n_smooth = float(n)+1.-log2(log2(log2(length(z))));
    // We take the 5th root to get a milder and smoother range of color.
    return pow(n_smooth/float(max_iter), 0.2);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Our coordinate system goes from (-2,-1) to (1,1), very roughly speaking.
    vec2 uv = 2.*fragCoord/iResolution.y-vec2(2.5,1.);
    const int max_iter = 500;
    const float divergence_threshold = 2.;
    float col = iter(uv, max_iter, divergence_threshold);
    fragColor = vec4(1.-col);
}
