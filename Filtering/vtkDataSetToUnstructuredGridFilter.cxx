/*=========================================================================

  Program:   Visualization Toolkit
  Module:    vtkDataSetToUnstructuredGridFilter.cxx

  Copyright (c) Ken Martin, Will Schroeder, Bill Lorensen
  All rights reserved.
  See Copyright.txt or http://www.kitware.com/Copyright.htm for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.

=========================================================================*/
#include "vtkDataSetToUnstructuredGridFilter.h"

#include "vtkUnstructuredGrid.h"

vtkCxxRevisionMacro(vtkDataSetToUnstructuredGridFilter, "1.26");

//----------------------------------------------------------------------------
vtkDataSetToUnstructuredGridFilter::vtkDataSetToUnstructuredGridFilter()
{
  this->NumberOfRequiredInputs = 1;
}

//----------------------------------------------------------------------------
vtkDataSetToUnstructuredGridFilter::~vtkDataSetToUnstructuredGridFilter()
{
}

//----------------------------------------------------------------------------
// Specify the input data or filter.
void vtkDataSetToUnstructuredGridFilter::SetInput(vtkDataSet *input)
{
  this->vtkProcessObject::SetNthInput(0, input);
}

//----------------------------------------------------------------------------
// Specify the input data or filter.
vtkDataSet *vtkDataSetToUnstructuredGridFilter::GetInput()
{
  if (this->NumberOfInputs < 1)
    {
    return NULL;
    }
  
  return (vtkDataSet *)(this->Inputs[0]);
}


//----------------------------------------------------------------------------
void vtkDataSetToUnstructuredGridFilter::PrintSelf(ostream& os, vtkIndent indent)
{
  this->Superclass::PrintSelf(os,indent);
}
