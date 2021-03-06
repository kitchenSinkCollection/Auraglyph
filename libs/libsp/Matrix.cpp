//
//  Matrix.cpp
//  Auraglyph
//
//  Created by Spencer Salazar on 1/1/19.
//  Copyright © 2019 Spencer Salazar. All rights reserved.
//

#include "Matrix.h"

#include <string.h>

const Matrix4 Matrix4::identity = Matrix4();

Matrix4 Matrix4::makeTranslation(float tx, float ty, float tz)
{
    return Matrix4(GLKMatrix4MakeTranslation(tx, ty, tz));
}

Matrix4 Matrix4::makeScale(float sx, float sy, float sz)
{
    return Matrix4(GLKMatrix4MakeScale(sx, sy, sz));
}

Matrix4 Matrix4::makeRotation(float radians, float rx, float ry, float rz)
{
    return Matrix4(GLKMatrix4MakeRotation(radians, rx, ry, rz));
}

Matrix4::Matrix4()
{
    m_mat = GLKMatrix4Identity;
}

Matrix4::Matrix4(const GLKMatrix4 &mat)
{
    m_mat = mat;
}

Matrix4 Matrix4::translate(float tx, float ty, float tz) const
{
    return Matrix4(GLKMatrix4Translate(m_mat, tx, ty, tz));
}

Matrix4 Matrix4::translate(const GLvertex3f &vec) const
{
    return Matrix4(GLKMatrix4Translate(m_mat, vec.x, vec.y, vec.z));
}

Matrix4 Matrix4::scale(float sx, float sy, float sz) const
{
    return Matrix4(GLKMatrix4Scale(m_mat, sx, sy, sz));
}

Matrix4 Matrix4::rotate(float radians, float rx, float ry, float rz) const
{
    return Matrix4(GLKMatrix4Rotate(m_mat, radians, rx, ry, rz));
}

Matrix4 Matrix4::multiply(const Matrix4 &mat) const
{
    return Matrix4(GLKMatrix4Multiply(m_mat, mat.m_mat));
}

Matrix4 &Matrix4::translateInPlace(float tx, float ty, float tz)
{
    m_mat = GLKMatrix4Translate(m_mat, tx, ty, tz);
    return *this;
}

Matrix4 &Matrix4::translateInPlace(const GLvertex3f &vec)
{
    m_mat = GLKMatrix4Translate(m_mat, vec.x, vec.y, vec.z);
    return *this;
}

Matrix4 &Matrix4::scaleInPlace(float sx, float sy, float sz)
{
    m_mat = GLKMatrix4Scale(m_mat, sx, sy, sz);
    return *this;
}

Matrix4 &Matrix4::rotateInPlace(float radians, float rx, float ry, float rz)
{
    m_mat = GLKMatrix4Rotate(m_mat, radians, rx, ry, rz);
    return *this;
}

Matrix4 &Matrix4::multiplyInPlace(const Matrix4 &mat)
{
    m_mat = GLKMatrix4Multiply(m_mat, mat.m_mat);
    return *this;
}

const float *Matrix4::data() const
{
    return m_mat.m;
}

Matrix4::operator GLKMatrix4 () const
{
    return m_mat;
}
