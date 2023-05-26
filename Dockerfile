FROM jupyter/minimal-notebook

USER nasim

RUN conda update conda
RUN conda config --remove channels conda-forge
RUN conda config --add channels conda-forge
RUN --set channel_priority strict


COPY environment.yml /home/nasim/
Run mamba env update -n base -f /home/nasim/environment.yml
# using ~/.bash_profile instead of ~/.bashrc for non-interactive tty (-it) containers
RUN echo "./opt/conda/etc/profile.d/conda.sh">> /home/nasim/.bash_profile && \
    echo "conda deactivate" >> /home/nasim/.bash_profile && \
    echo "conda activate base" >> /home/nasim/.bash_profile 
RUN . /opt/conda/etc/profile.d/conda.sh && conda activate base && python -m ipykernel install --user --name base
RUN source /home/nasim/.bash_profile

# Install JupyterLab widget extensions
RUN jupyter labextension install \
    ipyvolume \
    itkwidgets \
    jupyterlab_iframe \
    jupyter_leaflet \
    jupyter-threejs \ 
    nbgrader \
    
&& npm cache clean --force

RUN jupyter lab build

