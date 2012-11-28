#ifndef CIRC_BUFF_H_
#define CIRC_BUFF_H_

/*******************************************************
 * brief : This is used to implement a circular buffer
 *         containing an array of signed 16 bit integers
 * init  : To initialize point data in the direction
 *         of your data array set size to the size of
 *         the array and set position to 0
 * param : position is the position of the current newest
 *         sample
 ********************************************************/
struct c_buff_f32
{
    float *data;
    unsigned int size;
    unsigned int position;
};

/*********************************************
 * brief : Add the latest sample to the
 *         circular buffer
 *********************************************/
inline void push_new_f32(struct c_buff_f32 *buff, float sample)
{
    if( buff->position == 0 )
    {
        buff->position = buff->size - 1;
    }
    else
    {
        buff->position -= 1;
	}
	buff->data[buff->position] = sample;
}

/***********************************************
 * brief : Get the sample at index idx
 * e.g.  : The first sample (newest sample will
 *         be c_buff_ref_s16(c_buffer_addr, 0)
 *         the second newest sample will be
 *         c_buff_ref_s16(c_buffer_addr, 1)
 ************************************************/
inline short c_buff_ref_f32(struct c_buff_f32 *buff, unsigned int idx)
{
    return buff->data[(buff->position + idx) % buff->size];
}


#endif /*CIRC_BUFF_H_*/
