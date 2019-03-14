//
//  AGGenericShader.h
//  Auragraph
//
//  Created by Spencer Salazar on 8/16/13.
//  Copyright (c) 2013 Spencer Salazar. All rights reserved.
//

#ifndef __Auragraph__AGGenericShader__
#define __Auragraph__AGGenericShader__

#include "gfx.h"
#include "Geometry.h"
#include "ShaderHelper.h"
#include <string>

class AGGenericShader
{
public:
    
    static AGGenericShader &instance();
    
    virtual void useProgram();
    
    void setProjectionMatrix(const GLKMatrix4 &p);
    void setModelViewMatrix(const GLKMatrix4 &mv);
    
    void setMVPMatrix(const GLKMatrix4 &m);
    void setNormalMatrix(const GLKMatrix3 &m);
    
protected:
    AGGenericShader(const string &name = "Shader", EnableAttributes attributes = SHADERHELPER_PNC);
    AGGenericShader(const string &name, const map<int, string> &attributeMap);
    
    GLuint m_program;
    GLint m_uniformMVPMatrix;
    GLint m_uniformNormalMatrix;
    
    GLKMatrix4 m_proj;
    GLKMatrix4 m_mv;
};

class AGClipShader : public AGGenericShader
{
public:
    
    static AGClipShader &instance();
    
    void setClip(const GLvertex2f &origin, const GLvertex2f &size);
    void setLocalMatrix(const GLKMatrix4 &l);

private:
    AGClipShader();
    
    GLint m_uniformClipOrigin;
    GLint m_uniformClipSize;
    GLint m_uniformLocalMatrix;
};

class AGTextureShader : public AGGenericShader
{
public:
    
    static AGTextureShader &instance();
    
    virtual void useProgram();

protected:
    AGTextureShader();
    
    GLint m_uniformTex;
};


class AGWaveformShader : public AGGenericShader
{
public:
    
    static AGWaveformShader &instance();
    
    AGWaveformShader();
    
    virtual void useProgram();
    
    void setZ(const GLfloat z);
    void setGain(const GLfloat gain);
    void setWindowAmount(const GLfloat windowAmount);
    void setNumElements(const GLfloat numElements);

    static const GLint s_attribPositionX;
    static const GLint s_attribPositionY;
    
protected:
    GLfloat *m_xBuffer;
    GLint m_uniformPositionZ;
    GLint m_uniformGain;
    GLint m_uniformWindowAmount;
    GLint m_uniformNumElements;
};


#endif /* defined(__Auragraph__AGGenericShader__) */
