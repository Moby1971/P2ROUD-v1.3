function dicom_header = generate_dicomheader_DCM(app,dcmhead,parameters,fname,filecounter,dyncnt,FAcnt,TEcnt,slicecnt,dimx,dimy,dimz,nr_dynamics)

%
% GENERATES DICOM HEADER FOR EXPORT
%
% parameters = parameters from MRD file
% dcmhead = dicom info from scanner generated dicom
%
% frame = current frame number
% nr_frames = total number of frames
% dimy = y dimension (phase encoding, views)
% dimx = x dimension (readout, samples)
% 
%

frametime = 1000*parameters.acqdur/nr_dynamics;    % time between frames in ms

if app.seqpar.PHASE_ORIENTATION == 1
    pixely = app.FOVViewField1.Value/dimy;
    pixelx = app.FOVViewField2.Value/dimx;
else
    pixely = app.FOVViewField2.Value/dimy;
    pixelx = app.FOVViewField1.Value/dimx;
end


dcmhead.Filename = fname;
dcmhead.FileModDate = parameters.date;
dcmhead.FileSize = dimy*dimx*2;
dcmhead.Width = dimy;
dcmhead.Height = dimx;
dcmhead.BitDepth = 15;
dcmhead.InstitutionName = 'Amsterdam UMC';
dcmhead.ReferringPhysicianName.FamilyName = 'AMC preclinical MRI';
dcmhead.InstitutionalDepartmentName = 'Amsterdam UMC preclinical MRI';
dcmhead.PhysicianOfRecord.FamilyName = 'Amsterdam UMC preclinical MRI';
dcmhead.PerformingPhysicianName.FamilyName = 'Amsterdam UMC preclinical MRI';
dcmhead.PhysicianReadingStudy.FamilyName = 'Amsterdam UMC preclinical MRI';
dcmhead.OperatorName.FamilyName = 'manager';
dcmhead.ManufacturerModelName = 'MRS7024';
dcmhead.ReferencedFrameNumber = [];  
dcmhead.NumberOfAverages = parameters.NO_AVERAGES;
dcmhead.InversionTime = 0;
dcmhead.ImagedNucleus = '1H';
dcmhead.MagneticFieldStrength = 7;
dcmhead.TriggerTime = (dyncnt-1)*frametime;    % frame time (ms)
dcmhead.AcquisitionMatrix = uint16([dimx 0 0 dimy])';
dcmhead.AcquisitionDeviceProcessingDescription = '';
dcmhead.AcquisitionDuration = parameters.acqdur;
dcmhead.InstanceNumber = filecounter;          % instance number
dcmhead.TemporalPositionIdentifier = dyncnt;     % frame number
dcmhead.NumberOfTemporalPositions = nr_dynamics;
dcmhead.ImagesInAcquisition = nr_dynamics*dimz;
dcmhead.TemporalPositionIndex = dyncnt;
dcmhead.Rows = dimy;
dcmhead.Columns = dimx;
dcmhead.PixelSpacing = [pixely pixelx]';
dcmhead.PixelAspectRatio = [1 pixely/pixelx]';
dcmhead.BitsAllocated = 16;
dcmhead.BitsStored = 15;
dcmhead.HighBit = 14;
dcmhead.PixelRepresentation = 0;
dcmhead.PixelPaddingValue = 0;
dcmhead.RescaleIntercept = 0;
dcmhead.RescaleSlope = 1;
dcmhead.NumberOfSlices = dimz;


dcmhead.SliceThickness = parameters.SLICE_THICKNESS;
dcmhead.EchoTime = parameters.te*TEcnt;                 % ECHO TIME         
dcmhead.SpacingBetweenSlices = parameters.SLICE_SEPARATION/parameters.SLICE_INTERLEAVE;
dcmhead.EchoTrainLength = parameters.NO_ECHOES;
dcmhead.FlipAngle = parameters.flipanglearray(FAcnt);           % FLIP ANGLES

if isfield(dcmhead, 'SliceLocation')
    startslice = dcmhead.SliceLocation;
    dcmhead.SliceLocation = startslice+(slicecnt-1)*(parameters.SLICE_SEPARATION/parameters.SLICE_INTERLEAVE);
end

dicom_header = dcmhead;

end


