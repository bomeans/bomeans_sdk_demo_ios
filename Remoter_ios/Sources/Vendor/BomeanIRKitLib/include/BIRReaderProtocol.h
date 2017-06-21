//
//  BIRReaderProtocol.h
//  IRLib
//
//  Created by ldj on 2016/11/22.
//  Copyright © 2016年 lin. All rights reserved.
//

#ifndef BIRReaderProtocol_H__
#define BIRReaderProtocol_H__

#import <Foundation/Foundation.h>

enum PREFER_REMOTE_TYPE {
    /**
     * The best matched format is decided by the parsing core.
     */
    PREFER_REMOTE_TYPE_AUTO,
    /**
     * The best matched format is the AC format if any.<p>
     * If no AC format is matched, TV format will be selected
     */
    PREFER_REMOTE_TYPE_AC,
    /**
     * The best matched format is the TV format if any.<p>
     * If no TV format is matched, AC format will be selected
     */
    PREFER_REMOTE_TYPE_TV
};

enum LearningErrorCode {
    LEC_LearningModeFailed=50,
    LEC_TimeOut,
    LEC_IncorrectLearnedData,
    LEC_NoValidLearningData,
    LEC_UnrecognizedFormat,
    LEC_NoValidMatch,
    LEC_ServerError,
};

@class BIRRemoteUID;
@class BIRReaderMatchResult;
#define BIRRemoteMatchResult BIRRemoteUID



/*
 *  protocol BIRReaderRemoteMatchCallback
 */
@protocol BIRReaderRemoteMatchCallback <NSObject>

@required

/**
 * The matched remote controller(s) of the loaded learning data.<br>
 * Note: the matched remote controller list is the result of accumulated learning data since the last call of reset().
 * @param mCloudMatchResultList list of remote controller info
 obj in array is BIRRemoteMatchResult
 */
-(void) onRemoteMatchSucceeded : (NSArray*) remoteMatchResult;

/**
 * If failed to find the matched remote in the cloud database.
 * @param errorCode error code
 */
-(void) onRemoteMatchFailed : (int) errorCode;


/**
 * Invoked if matched format of the learned result(s) is found.<br>
 * Note: The matched results are accumulated if not calling reset()
 * @param formatMatchResultList the matched result list
 *  obj in NSArray is BIRReaderMatchResult
 */
-(void) onFormatMatchSucceeded: (NSArray*)  formatMatchResultList;

/**
 * Invoked if no matched format of the learned result(s) is found.
 * @param errorCode error code
 */
-(void) onFormatMatchFailed:(int) errorCode;



@end   // end of protocol BIRReaderRemoteMatchCallback



/*
 *   protocol BIRReaderFormatMatchCallback
 */
@protocol BIRReaderFormatMatchCallback <NSObject>

/**
 * Invoked if matched format of learned result is found.<br>
 * @param formatMatchResult matched result
 */
-(void) onFormatMatchSucceeded : (BIRReaderMatchResult*) formatMatchResult;

/**
 * Invoked if there is no match for the learned result.
 * @param errorCode error code
 */
-(void) onFormatMatchFailed : (int) errorCode;

/**
 * Invoked when the learning data is received.
 * @param learningData the learned IR signal data. This data can be stored and re-transmit by calling sendLearningData(byte[] data)
 */
-(void) onLearningDataReceived : (NSData*) learningData;

/**
 * Invoked when the learning data is not received or is incorrect.
 * @param errorCode
 */
-(void) onLearningDataFailed : (int) errorCode;

@end   // end of protocol BIRReaderFormatMatchCallback





/////
////  protocol BIRReader
////
@protocol BIRReader <NSObject>

/**
 * <b>Note</b> This method is for debug purpose.<br>
 * Not to call this method unless you understand its usage.<p>
 * Loading learning data into the reader for parsing.
 *
 * @param data data bytes to be parsed
 * @param isPayloadOnly true if the passing data bytes are payload data only (exclude the prefix, postfix, checksum,..etc),
 * or false if the passing data contains the full packet returned from the MCU (the full packet looks like this: 0xFF, 0x61, ..., 0xF0)
 * @param isCompressedFormat true if the containing payload data are in compressed format, or false if in plain(uncompressed) format.
 * (note: most likely it's in compressed format, so if unsure, set it to true)
 * @return true if the passing data is valid
 */
-(BOOL) loadData : (NSData*)data
  isPayloadOnly : (BOOL) payloadOnly
    isCompressed : (BOOL) compressedFormat;


/**
 * Get the best matched format(s) of the passing learning data.
 * The best match(es) might not be only. But most likely you can pick the first entry as the best one.
 * Note the best match(es) might contain TV and AC results. You can filter the result by checking the
 * ReaderMatchResult::isAc().
 * @return best matched format(s) of the loaded learning data . The object in Array is ReaderMatchResult
 */
-(NSArray*) getBestMatches;


/**
 * All the other matched formats not treated as the "best" ones.
 * @return the possible matched format(s) of the loaded learning data. The object in Array is BIRReaderMatchResult
 */
-(NSArray*) getPossibleMatches;


/**
 * getBestMatches() + getPossibleMatches()
 * @return   The object in Array is BIRReaderMatchResult
 */
-(NSArray*) getAllMatches;


/**
 * <b>Note</b> This method is for debug purpose.<br>
 * Get the wave count (number of on/off IR signals) of the loaded learning data.
 *
 * @return the wave count (number of on/off IR signals) of the loaded data
 */
-(int) getWaveCount;

/**
 * <b>Note</b> This method is for debug purpose.<br>
 * Get the carrier frequency of the loaded learning data.
 * @return carrier frequency, in Hz
 */
-(int) getFrequency;


/**
 * Start the learning process, and get the learned raw data as well as the matched format in the passing callback functions.<br>
 * <b>Note</b>: Only format matching is processed in this call. If you need to search the cloud server
 * for matching remote controllers, call <i>startLearningAndSearchCloud()</i>
 * @param preferRemoteType AC, TV, or Auto. This affects the decision of the "best match" returned.
 * @param callback To receive the learning/parsing results
 */
-(void) startLearningAndGetData : (int) preferRemoteType
                   withCallBack : (id<BIRReaderFormatMatchCallback>) callback;



/**
 * Start the learning process, get the matched format and matched remote controller(s) in the passing callback functions.<br>
 * @param isNewSearch Set to true if you are starting a new learning. Set to false if you are adding the learning to filter the previous matched result.
 * @param preferRemoteType AC, TV, or Auto. This affects the decision of the "best match" returned.
 * @param callback To receive the parsing/searching results
 */
-(void) startLearningAndSearchCloud : (BOOL) isNewSearch
                         remoteType : (int) preferRemoteType
                       withCallBack : (id<BIRReaderRemoteMatchCallback>) callback;

/**
 * Reset the internal learning states if you have previous called startLearningAndSearchCloud().
 */
-(void) reset;

/**
 * Send the stop learning command to IR Blaster. (Return to normal mode)
 * @return ConstValue.BIROK if succeeded, other error code if failed
 */
-(int) stopLearning;

/**
 * Send the learned IR signal.<br>
 *
 * @param learningData The learning data get from startLearningAndGetData();
 */
/**
 * Send the learned IR signal.<br>
 * @param learningData The learning data get from startLearningAndGetData().
 *  NSData is a byte data
 * @return ConstValue.BIROK if succeeded, other error code if failed
 */
-(int) sendLearningData : (NSData*) learningData;




@end


#endif /* BIRReaderProtocol_H__ */
