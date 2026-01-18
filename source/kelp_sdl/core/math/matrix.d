module kelp_sdl.core.math.matrix;

import kelp_core.math.linalg.matrix;
import std.math : isNaN;

align(16) struct SDL_Matrix
{

	float m11, m12, m13, m14;
	float m21, m22, m23, m24;
	float m31, m32, m33, m34;
	float m41, m42, m43, m44;
}

SDL_Matrix toSDL(in Matrix!(4, 4) matrix)
in
{
	static foreach (row; 0 .. 4)
	{
		static foreach (col; 0 .. 4)
		{
			assert(matrix[row, col].isNaN == false);
		}
	}
}
do
{
	SDL_Matrix temp;
	temp.m11 = matrix[0, 0];
	temp.m12 = matrix[0, 1];
	temp.m13 = matrix[0, 2];
	temp.m14 = matrix[0, 3];
	temp.m21 = matrix[1, 0];
	temp.m22 = matrix[1, 1];
	temp.m23 = matrix[1, 2];
	temp.m24 = matrix[1, 3];
	temp.m31 = matrix[2, 0];
	temp.m32 = matrix[2, 1];
	temp.m33 = matrix[2, 2];
	temp.m34 = matrix[2, 3];
	temp.m41 = matrix[3, 0];
	temp.m42 = matrix[3, 1];
	temp.m43 = matrix[3, 2];
	temp.m44 = matrix[3, 3];
	return temp;
}
