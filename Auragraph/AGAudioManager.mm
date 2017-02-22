//
//  AGAudioManager.m
//  ;
//
//  Created by Spencer Salazar on 8/13/13.
//  Copyright (c) 2013 Spencer Salazar. All rights reserved.
//

#import "AGAudioManager.h"
#import "AGNode.h"
#import "AGAudioNode.h"
#import "AGTimer.h"

#import "mo_audio.h"

#import "Mutex.h"
#import "spstl.h"

class AGAudioManagerOutputDestination : public AGAudioOutputDestination
{
public:
    
    AGAudioManagerOutputDestination(AGAudioManager *manager) :
    m_manager(manager)
    { }
    
    void addOutput(AGAudioRenderer *renderer) override
    {
        [m_manager addRenderer:renderer];
    }
    
    virtual void removeOutput(AGAudioRenderer *renderer) override
    {
        [m_manager removeRenderer:renderer];
    }
    
private:
    AGAudioManager *m_manager;
};


@interface AGAudioManager ()
{
    sampletime t;
    
    list<AGAudioRenderer *> _renderers;
    Mutex _renderersMutex;
    list<AGAudioCapturer *> _capturers;
    Mutex _capturersMutex;
    list<AGTimer *> _timers;
    Mutex _timersMutex;
    
    float _inputBuffer[1024];
    Buffer<float> _outputBuffer;
}

- (void)renderAudio:(Float32 *)buffer numFrames:(UInt32)numFrames;

@end


void audio_cb( Float32 * buffer, UInt32 numFrames, void * userData )
{
    [(__bridge AGAudioManager *)userData renderAudio:buffer numFrames:numFrames];
}

static AGAudioManager *g_audioManager;


@implementation AGAudioManager

+ (instancetype)instance
{
    return g_audioManager;
}

- (id)init
{
    if(self = [super init])
    {
        g_audioManager = self;
        
        self.masterOut = new AGAudioManagerOutputDestination(self);
        
        t = 0;
        
        _outputBuffer.resize(1024*2);
        _outputBuffer.clear();
        
        memset(_inputBuffer, 0, sizeof(float)*1024);
        
        MoAudio::init(AGAudioNode::sampleRate(), AGAudioNode::bufferSize(), 2);
        MoAudio::start(audio_cb, (__bridge void *) self);
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_DELETE(self.masterOut);
}

- (void)addRenderer:(AGAudioRenderer *)renderer
{
    _renderersMutex.lock();
    _renderers.push_back(renderer);
    _renderersMutex.unlock();
}

- (void)removeRenderer:(AGAudioRenderer *)renderer
{
    _renderersMutex.lock();
    _renderers.remove(renderer);
    _renderersMutex.unlock();
}

- (void)addCapturer:(AGAudioCapturer *)capturer
{
    _capturersMutex.lock();
    _capturers.push_back(capturer);
    _capturersMutex.unlock();
}

- (void)removeCapturer:(AGAudioCapturer *)capturer
{
    _capturersMutex.lock();
    _capturers.remove(capturer);
    _capturersMutex.unlock();
}

- (void)addTimer:(AGTimer *)timer
{
    _timersMutex.lock();
    _timers.push_back(timer);
    _timersMutex.unlock();
}

- (void)removeTimer:(AGTimer *)timer
{
    _timersMutex.lock();
    _timers.remove(timer);
    _timersMutex.unlock();
}


- (void)renderAudio:(Float32 *)buffer numFrames:(UInt32)numFrames
{
    _outputBuffer.clear();
    
    _timersMutex.lock();
    for(AGTimer *timer : _timers )
    {
        float tf = ((float)t)/((float)AGAudioNode::sampleRate());
        float dtf = ((float)numFrames)/((float)AGAudioNode::sampleRate());
        timer->checkTimer(tf, dtf);
    };
    _timersMutex.unlock();
    
    for(int i = 0; i < numFrames; i++)
    {
        _inputBuffer[i] = buffer[i*2];
    }
    
    _capturersMutex.lock();
    for(AGAudioCapturer *capturer : _capturers)
        capturer->captureAudio(_inputBuffer, numFrames);
    _capturersMutex.unlock();
    
    _renderersMutex.lock();
    for(AGAudioRenderer *renderer : _renderers)
        renderer->renderAudio(t, NULL, _outputBuffer, numFrames, 0, 2);
    _renderersMutex.unlock();
    
    for(int i = 0; i < numFrames; i++)
    {
        buffer[i*2] = _outputBuffer[i*2];
        buffer[i*2+1] = _outputBuffer[i*2+1];
    }
    
    t += numFrames;
}


@end



_AGAudioManager &_AGAudioManager::instance()
{
    static _AGAudioManager s_instance;
    return s_instance;
}

void _AGAudioManager::addRenderer(AGAudioRenderer *renderer)
{
    [[AGAudioManager instance] addRenderer:renderer];
}

void _AGAudioManager::removeRenderer(AGAudioRenderer *renderer)
{
    [[AGAudioManager instance] removeRenderer:renderer];
}

void _AGAudioManager::addCapturer(AGAudioCapturer *capturer)
{
    [[AGAudioManager instance] addCapturer:capturer];
}

void _AGAudioManager::removeCapturer(AGAudioCapturer *capturer)
{
    [[AGAudioManager instance] removeCapturer:capturer];
}

void _AGAudioManager::addTimer(AGTimer *timer)
{
    [[AGAudioManager instance] addTimer:timer];
}

void _AGAudioManager::removeTimer(AGTimer *timer)
{
    [[AGAudioManager instance] removeTimer:timer];
}
