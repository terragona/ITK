/*==========================================================================

  Program:   Insight Segmentation & Registration Toolkit
  Module:    itkImageScalarIterator.h
  Language:  C++
  Date:      $Date$
  Version:   $Revision$

  Copyright (c) 2000 National Library of Medicine
  All rights reserved.

  See COPYRIGHT.txt for copyright details.
  
==========================================================================*/
/**
 * itkImageScalarIterator is a templated class to represent a
 * multi-dimensional iterator. It is a specialized form of
 * itkImageIterator that invokes the GetScalar() method. GetScalar() is
 * used when you want to write a filter that processes only the scalar
 * portion of a pixel.  
 */

#ifndef __itkImageScalarIterator_h
#define __itkImageScalarIterator_h

#include "itkImageIterator.h"

template<class TPixel, unsigned int TImageDimension=2>
class itkImageScalarIterator : public itkImageIterator<TPixel,TImageDimension> {
public:
  /**
   * Dereference the iterator, returns a reference to the pixel. Used to set
   * or get the value referenced by the index.
   */
  TPixel& operator*() const  
    { return itkPixelTraits<TPixel>::GetScalar(*( m_Image + m_Offset )); }
  
};

#endif 
