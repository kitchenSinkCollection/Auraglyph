//
//  AGOutputNode.cpp
//  Auragraph
//
//  Created by Spencer Salazar on 8/21/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#include "AGOutputNode.h"
#include "AGGenericShader.h"
#include "AGStyle.h"

//------------------------------------------------------------------------------
// ### AGOutputNode ###
//------------------------------------------------------------------------------
#pragma mark - AGOutputNode

bool AGOutputNode::s_init = false;
GLuint AGOutputNode::s_vertexArray = 0;
GLuint AGOutputNode::s_vertexBuffer = 0;
GLvncprimf *AGOutputNode::s_geo = NULL;
GLuint AGOutputNode::s_geoSize = 0;
float AGOutputNode::s_radius = 0;

void AGOutputNode::initializeOutputNode()
{
    initalizeNode();
    
    if(!s_init)
    {
        s_init = true;
        
        // generate triangle
        s_geoSize = 3;
        s_geo = new GLvncprimf[s_geoSize];
        s_radius = AGNode::s_sizeFactor/G_RATIO;
        
        s_geo[0].vertex = GLvertex3f(-s_radius, -s_radius, 0);
        s_geo[1].vertex = GLvertex3f(s_radius, -s_radius, 0);
        s_geo[2].vertex = GLvertex3f(0, sqrtf(s_radius*s_radius*4 - s_radius*s_radius) - s_radius, 0);
        
        glGenVertexArraysOES(1, &s_vertexArray);
        glBindVertexArrayOES(s_vertexArray);
        
        glGenBuffers(1, &s_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, s_vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, s_geoSize*sizeof(GLvncprimf), s_geo, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(AGVertexAttribPosition);
        glVertexAttribPointer(AGVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLvncprimf), BUFFER_OFFSET(0));
        glEnableVertexAttribArray(AGVertexAttribNormal);
        glVertexAttribPointer(AGVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(GLvncprimf), BUFFER_OFFSET(sizeof(GLvertex3f)));
        glEnableVertexAttribArray(AGVertexAttribColor);
        glVertexAttribPointer(AGVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(GLvncprimf), BUFFER_OFFSET(2*sizeof(GLvertex3f)));
        
        glBindVertexArrayOES(0);
    }
}

AGOutputNode::AGOutputNode(const AGNodeManifest *mf, const GLvertex3f &pos) :
AGNode(mf, pos)
{
    initializeOutputNode();
}

void AGOutputNode::update(float t, float dt)
{
    AGNode::update(t, dt);
    
    GLKMatrix4 projection = projectionMatrix();
    GLKMatrix4 modelView = globalModelViewMatrix();
    
    modelView = GLKMatrix4Translate(modelView, m_pos.x, m_pos.y, m_pos.z);
    
    m_normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelView), NULL);
    
    m_modelViewProjectionMatrix = GLKMatrix4Multiply(projection, modelView);
}

void AGOutputNode::render()
{
    glBindVertexArrayOES(s_vertexArray);
    
    AGStyle::foregroundColor().withAlpha(m_fadeOut).set();
    glDisableVertexAttribArray(AGVertexAttribColor);
    
    // TODO
    AGGenericShader &shader = AGGenericShader::instance();
    shader.useProgram();
    shader.setMVPMatrix(m_modelViewProjectionMatrix);
    shader.setNormalMatrix(m_normalMatrix);
    
    glLineWidth(4.0f);
    glDrawArrays(GL_LINE_LOOP, 0, s_geoSize);
}

AGNode::HitTestResult AGOutputNode::hit(const GLvertex3f &hit)
{
    return HIT_NONE;
}

void AGOutputNode::unhit()
{
    
}

AGUIObject *AGOutputNode::hitTest(const GLvertex3f &t)
{
    GLvertex2f posxy = m_pos.xy();
    if(pointInTriangle(t.xy(), s_geo[0].vertex.xy()+posxy,
                       s_geo[2].vertex.xy()+posxy,
                       s_geo[1].vertex.xy()+posxy))
        return this;
    return NULL;
}



