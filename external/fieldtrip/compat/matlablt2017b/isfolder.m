function [varargout] = isfolder(varargin)

%ISFOLDER Determine if the input path points to a folder
%   TF = ISFOLDER(PATH) returns true if PATH points to a folder and false otherwise.
%
% This is a compatibility function that should only be added to the path on
% MATLAB versions prior to R2017b.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% see https://github.com/fieldtrip/fieldtrip/issues/899

alternatives = which(mfilename, '-all');
if ~iscell(alternatives)
  % this is needed for octave, see https://github.com/fieldtrip/fieldtrip/pull/1171
  alternatives = {alternatives};
end

keep = true(size(alternatives));
for i=1:numel(alternatives)
  keep(i) = keep(i) && ~any(alternatives{i}=='@');  % exclude methods from classes
  keep(i) = keep(i) && alternatives{i}(end)~='p';   % exclude precompiled files
end
alternatives = alternatives(keep);

if exist(mfilename, 'builtin') || any(strncmp(alternatives, matlabroot, length(matlabroot)) & cellfun(@isempty, strfind(alternatives, fullfile('private', mfilename))))
  % remove this directory from the path
  p = fileparts(mfilename('fullpath'));
  sw = warning('off','backtrace');
  warning('Removing "%s" from your path.\nSee http://www.fieldtriptoolbox.org/faq/should_i_add_fieldtrip_with_all_subdirectories_to_my_matlab_path/', p);
  warning(sw);
  rmpath(p);
  % call the original MATLAB function
  if exist(mfilename, 'builtin')
    [varargout{1:nargout}] = builtin(mfilename, varargin{:});
  else
    [varargout{1:nargout}] = feval(mfilename, varargin{:});
  end
  return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is where the actual replacement code starts
% function tf = isfolder(input)

% deal with the input arguments
if nargin==1
  [input] = deal(varargin{1:1});
else
  error('incorrect number of input arguments')
end

tf = exist(input,'dir') == 7;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deal with the output arguments

varargout = {tf};
